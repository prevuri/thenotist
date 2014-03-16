@NoteCtrl = ($scope, $http, $route, $routeParams, $sce, $timeout, $interval, NotesApi) ->
  # Group comment lines up to this nubmer of pixels apart
  @groupThreshold = 60

  $route.current.templateUrl = '/ng/notes/' + $routeParams.noteId

  $scope.$on('$destroy', () ->
    $interval.cancel($scope.pollPromise)
    $scope.$root.pageShifted = false
  )

  # number of pages to loaded in the browser at any given time
  $scope.pageChunkSize = 10
  $scope.repliesShowing = {}
  $scope.replyText = {}
  $scope.showDeleteConfirm = {global: null}
  $scope.currentPage = 1
  $scope.pageEl = {}
  $scope.lineYCache = {}
  $scope.placeholderHeight = 0

  $scope.$watch('currentPage', () =>
    $scope.loadVisiblePages()
  )

  $scope.init = () ->
    $scope.$root.section = 'notes'
    success = (data) ->
      $scope.note = data.note
      if $scope.note.user.id == $scope.currentUser.id
        $scope.note.shared = false
      else
        $scope.note.shared = true
      $scope.setupPageChunks()
      $scope.loadVisiblePages()
      $scope.$root.title = $scope.note.title
      $scope.trustURLs()
      $scope.getComments()
      $scope.pollComments()
    error = (data) ->
      console.log "Error loading note data"
    NotesApi.get({id: $routeParams.noteId}, success, error)

  $scope.setupPageChunks = () =>
    $scope.pageChunks = []
    currrentGroup = []
    i = 0
    while i < $scope.note.uploaded_html_files.length
      pageChunk = $scope.note.uploaded_html_files.slice(i, i+$scope.pageChunkSize)
      obj = {visible: false, commentsLoaded: false, pages: pageChunk}
      $scope.pageChunks.push(obj)
      i += $scope.pageChunkSize

  # Sets the current note being shared for the sharing modal
  $scope.setSharedNote = () ->
    $scope.sharedNote = $scope.note
    $scope.$broadcast('shareInit')

  $scope.trustURLs = () ->
    for file in $scope.note.uploaded_html_files
      file.trusted_path = $sce.trustAsResourceUrl(file.public_path)

  $scope.getGroupedComments = (file) ->
    if !file.pageEl
      file.pageEl = $('.page-contents').get(file.page_number)
    if file.pageEl && $(file.pageEl).is(':visible')
      file.groupedComments = $scope.groupComments(file.comments)
    else
      file.groupedComments = null
    if file.groupedComments == null
      $timeout(() =>
        file.groupErrorCount = if file.groupErrorCount then file.groupErrorCount+1 else 1
        if file.groupErrorCount < 20
          angular.element(document).ready( () ->
            $scope.getGroupedComments(file)
          )
        else
          console.log "Error processing note comment data"
      , 500 + Math.floor(file.groupErrorCount/10)*1000)
    else
      $scope.$root.loading = false

  $scope.pollComments = () ->
    $scope.pollPromise = $interval( () =>
      $scope.getComments()
    , 30000)

  $scope.getComments = () ->
    $http({method: 'GET', url: '/api/comments', params: {note_id: $scope.note.id}}).
      success( (data, status, headers, config) ->
        parentComments = []
        updateChunk = false
        chunkFirstPageNo = $scope.pageChunks[$scope.currentPageChunk].pages[0].page_number
        chunkLastPageNo = chunkFirstPageNo + $scope.pageChunkSize-1
        for comment in data.comments
          # If this is a parent comment (not a reply)
          if !comment.parent_comment_id
            parentComments.push(comment)
        commentsByFile = {}
        for file in $scope.note.uploaded_html_files
          commentsByFile[file.id] = []
        for comment in parentComments
          commentsByFile[comment.uploaded_html_file_id].push(comment)
        for file in $scope.note.uploaded_html_files
          shouldUpdate = false
          if !file.comments
            shouldUpdate = true
          else
            oldComments = file.comments.map((value) ->
              angular.copy(value)
            )
            shouldUpdate = JSON.stringify(oldComments) != JSON.stringify(commentsByFile[file.id])
          if shouldUpdate
            file.comments = commentsByFile[file.id]
            if file.page_number >= chunkFirstPageNo && file.page_number <= chunkLastPageNo
              updateChunk = true
        for chunk in $scope.pageChunks
          chunk.commentsLoaded = false
        # Don't group visible chunk comments on initial comment request; loadVisiblePages already does this
        if updateChunk && $scope.initialCommentRequestDone
          $scope.groupCommentsCurrentChunk()
        $scope.initialCommentRequestDone = true
      ).error( (data, status, headers, config) ->
        console.log "Error loading comments from server", false
    )

  $scope.showNewComment = (show) ->
    $scope.showingNewComment = show
    $scope.$root.pageShifted = show

  $scope.lineClick = (lineId) ->
    $scope.newCommentLineId = lineId
    $scope.parentId = null
    $scope.showNewComment(true)
    lineEl = $('[data-guid='+lineId+']')
    $scope.newCommentY = $(lineEl).offset().top
    $scope.newCommentFileId = this.$parent.file.id
    $scope.newCommentFileIndex = this.pageNo-1
    $scope.expandedCommentLine = null

  $scope.commentY = (lineId) =>
    if !(lineId of $scope.lineYCache)
      el = $('[data-guid='+lineId+']')
      if el.length == 0
        return null
      else
        $scope.lineYCache[lineId] = $(el).offset().top - $(el).parents('.note-page').offset().top
    $scope.lineYCache[lineId]

  $scope.canReply = (comment) ->
    comment.parent_comment_id == null

  $scope.expandCommentLine = (lineId) ->
    $scope.expandedCommentLine = if $scope.expandedCommentLine == lineId then null else lineId
    $scope.$root.pageShifted = $scope.expandedCommentLine != null
    if $scope.expandedCommentLine != null
      $scope.showingNewComment = false

  $scope.submitParentComment = () ->
    $scope.submitComment($scope.newCommentText, $scope.newCommentFileId, null, $scope.newCommentFileIndex)

  $scope.submitReply = (parentComment, fileId, fileIndex) ->
    $scope.submitComment($scope.replyText[parentComment.id], fileId, parentComment.id, fileIndex)

  $scope.submitComment = (text, fileId, parentId, fileIndex) ->
    if !$scope.submitting
      data = {
        comment: {
          text: text,
        },
        file_id: fileId
      }
      if parentId
        data['comment']['parent_id'] = parentId
      else
        data['comment']['line_id'] = $scope.newCommentLineId

      $scope.submitting = true
      $http({method: 'POST', url: '/api/comments', data: data}).
        success( (data, status, headers, config) ->
          $scope.submitting = false
          if parentId
            $scope.repliesShowing[parentId] = false
            $scope.replyText[parentId] = null
          else
            $scope.expandCommentLine($scope.newCommentLineId)
            $scope.newCommentText = null
          $scope.note.uploaded_html_files[fileIndex].comments = data.comments
          $scope.note.uploaded_html_files[fileIndex].groupedComments = $scope.groupComments(data.comments)
        ).error( (data, status, headers, config) ->
          # TODO: error message of some sort
          $scope.submitting = false
      )

  $scope.deleteComment = (comment, fileIndex) ->
    $scope.showDeleteConfirm.global = null
    comment.deleteFade = true
    $http({method: 'DELETE', url: '/api/comments/' + comment.id}).
        success( (data, status, headers, config) ->
          comment.deleted = true
          if comment.parent_comment_id == null
            $scope.getGroupedComments($scope.note.uploaded_html_files[fileIndex])
        ).error( (data, status, headers, config) ->
          $scope.setAlert("Error deleting comment", false)
          comment.deleteFade = false
      )

  $scope.groupComments = (comments) =>
    groupedComments = []
    if !comments
      return null
    for comment in comments
      if $scope.commentY(comment.line_id) == null
        return null
      if !comment.deleted
        groupedComments.push {
          lineId: comment.line_id,
          yCoord: $scope.commentY(comment.line_id),
          comments: [comment]
        }
    groupedComments.sort((a, b) ->
      a.yCoord > b.yCoord
    )
    i = 1
    while i < groupedComments.length
      if groupedComments[i].yCoord - groupedComments[i-1].yCoord < @groupThreshold
        if groupedComments[i].lineId == $scope.expandedCommentLine
          $scope.expandedCommentLine = groupedComments[i-1].lineId
        groupedComments[i-1].comments = groupedComments[i-1].comments.concat(groupedComments[i].comments)
        groupedComments.splice(i, 1)
      else
        i++
    groupedComments

  $scope.incrementPage = () ->
    if $scope.currentPage < $scope.note.uploaded_html_files.length
      $scope.currentPage++
    $scope.pageEl[$scope.currentPage].scrollToPage = true

  $scope.decrementPage = () ->
    if $scope.currentPage > 1
      $scope.currentPage--
    $scope.pageEl[$scope.currentPage].scrollToPage = true

  $scope.changeVisibleChunk = (old, current) ->
    $scope.pageChunks[current].visible = true
    if current > 0
      $scope.pageChunks[current-1].visible = true
    if current < $scope.pageChunks.length-1
      $scope.pageChunks[current+1].visible = true
    if old == undefined
      return
    if old != current-1 && old != current+1
      $scope.pageChunks[old].visible = false
    if old != current+1
      if old > 0
        $scope.pageChunks[old-1].visible = false
    if old != current-1
      if old < $scope.pageChunks.length-1
        $scope.pageChunks[old+1].visible = false

  $scope.getPlaceholderHeight = () =>
    if $('.page-contents .pf').length > 0 && $('.page-contents .pf').first().is(':visible')
      $scope.placeholderHeight = $('.page-contents').eq($scope.currentPage-1).height()
    else
      $timeout(() =>
        $scope.getPlaceholderHeight()
      , 200)


  $scope.groupCommentsCurrentChunk = () ->
    for page in $scope.pageChunks[$scope.currentPageChunk].pages
      $scope.getGroupedComments(page)
    $scope.pageChunks[$scope.currentPageChunk].commentsLoaded = true


  $scope.loadVisiblePages = () =>
    if !$scope.note
      return
    newChunk = Math.floor(($scope.currentPage-1) / $scope.pageChunkSize)# Index of current chunk
    if newChunk == $scope.currentPageChunk
      return
    $scope.changeVisibleChunk($scope.currentPageChunk, newChunk)
    $scope.currentPageChunk = newChunk
    if !$scope.pageChunks[$scope.currentPageChunk].commentsLoaded
      $scope.groupCommentsCurrentChunk()
    if $scope.placeholderHeight < 50
      $scope.getPlaceholderHeight()
