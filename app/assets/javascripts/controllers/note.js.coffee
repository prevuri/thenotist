@NoteCtrl = ($scope, $http, $route, $routeParams, $sce, $timeout, $interval, NotesApi) ->
  # Group comment lines up to this nubmer of pixels apart
  @groupThreshold = 60

  # number of pages to loaded in the browser at any given time
  @prefetchSize = 10

  $route.current.templateUrl = '/ng/notes/' + $routeParams.noteId

  $scope.$on('$destroy', () ->
    $interval.cancel($scope.pollPromise)
    $scope.$root.pageShifted = false
  )

  $scope.repliesShowing = {}
  $scope.replyText = {}
  $scope.showDeleteConfirm = {global: null}
  $scope.currentPage = 1
  $scope.visiblePages = []

  $scope.init = () ->
    $scope.$root.section = 'notes'
    success = (data) ->
      $scope.note = data.note
      if $scope.note.user.id == $scope.currentUser.id
        $scope.note.shared = false
      else
        $scope.note.shared = true
      $scope.loadMoreVisiblePages()
      $scope.$root.title = $scope.note.title
      $scope.trustURLs()
      $scope.getComments()
      $scope.pollComments()
    error = (data) ->
      console.log "Error loading note data"
    NotesApi.get({id: $routeParams.noteId}, success, error)

  # Sets the current note being shared for the sharing modal
  $scope.setSharedNote = () ->
    $scope.sharedNote = $scope.note
    $scope.$broadcast('shareInit')

  $scope.trustURLs = () ->
    for file in $scope.note.uploaded_html_files
      file.trusted_path = $sce.trustAsResourceUrl(file.public_path)

  $scope.getGroupedComments = (file) ->
    file.groupedComments = $scope.groupComments(file.comments)
    if file.groupedComments == null
      $timeout(() =>
        file.groupErrorCount = if file.groupErrorCount then file.groupErrorCount+1 else 1
        if file.groupErrorCount < 10
          angular.element(document).ready( () ->
            $scope.getGroupedComments(file)
          )
        else
          console.log "Error processing note comment data"
      , 500)
    else

  $scope.pollComments = () ->
    $scope.pollPromise = $interval( () =>
      $scope.getComments()
    , 30000)

  $scope.getComments = () ->
    $http({method: 'GET', url: '/api/comments', params: {note_id: $scope.note.id}}).
      success( (data, status, headers, config) ->
        parentComments = []
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
            angular.element(document).ready( () ->
              $scope.getGroupedComments(file)
            )
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
    $scope.newCommentFileIndex = this.$parent.$index
    $scope.expandedCommentLine = null

  $scope.commentY = (lineId) =>
    el = $('[data-guid='+lineId+']')
    if el.length == 0
      @stillLoading = true
      null
    else
      $(el).offset().top - $(el).parents('.note-page').offset().top

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
          $scope.visiblePages[fileIndex].comments = data.comments
          $scope.visiblePages[fileIndex].groupedComments = $scope.groupComments(data.comments)
          $scope.submitting = false
          if parentId
            $scope.repliesShowing[parentId] = false
            $scope.replyText[parentId] = null
          else
            $scope.showNewComment(false)
            $scope.newCommentText = null
        ).error( (data, status, headers, config) ->
          # TODO: error message of some sort
          $scope.submitting = false
      )

  $scope.deleteComment = (comment) ->
    $scope.showDeleteConfirm.global = null
    comment.deleteFade = true
    $http({method: 'DELETE', url: '/api/comments/' + comment.id}).
        success( (data, status, headers, config) ->
          comment.deleted = true
        ).error( (data, status, headers, config) ->
          $scope.setAlert("Error deleting comment", false)
          comment.deleteFade = false
      )

  $scope.groupComments = (comments) =>
    groupedComments = []
    for comment in comments
      if $scope.commentY(comment.line_id) == null
        return null
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

  $scope.decrementPage = () ->
    if $scope.currentPage > 1
      $scope.currentPage--

  $scope.loadMoreVisiblePages = () =>
    if !$scope.note
      return false
    if $scope.note && $scope.note.uploaded_html_files.length == $scope.visiblePages.length
      return false
    rangeEnd = Math.min($scope.visiblePages.length + @prefetchSize, $scope.note.uploaded_html_files.length)
    $scope.visiblePages = $scope.note.uploaded_html_files.slice(0, rangeEnd)
    return false
