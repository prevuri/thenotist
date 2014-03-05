@NoteCtrl = ($scope, $http, $route, $routeParams, $sce, $timeout, $interval, NotesApi) ->

  $route.current.templateUrl = '/ng/notes/' + $routeParams.noteId

  $scope.$on('$destroy', () ->
    $scope.$root.pageShifted = false
  )

  # Group comment lines up to this nubmer of pixels apart
  @groupThreshold = 60

  $scope.init = () ->
    $scope.$root.section = 'notes'
    success = (data) ->
      $scope.note = data.note
      $scope.$root.title = $scope.note.title
      $scope.trustURLs()
      $scope.pollComments()
    error = (data) ->
      $scope.setAlert("Error loading note data", false)
    NotesApi.get({id: $routeParams.noteId}, success, error)

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
          $scope.setAlert("Error processing note comment data")
      , 500)
    else

  $scope.pollComments = () ->
      $interval( () =>
        for file, i in $scope.note.uploaded_html_files
          $scope.getComments(file.id, i)
      , 5000)

  $scope.getComments = (id, index) ->
    $http({method: 'GET', url: '/api/comments', params: {file_id: id}}).
      success( (data, status, headers, config) ->
        $scope.note.uploaded_html_files[index].comments = data.comments
        angular.element(document).ready( () ->
          $scope.getGroupedComments($scope.note.uploaded_html_files[index])
        )
      ).error( (data, status, headers, config) ->
        $scope.setAlert("Error loading comments from server", false)
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
    $scope.submitComment(parentComment.newReplyText, fileId, parentComment.id, fileIndex)

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
          $scope.note.uploaded_html_files[fileIndex].comments = data.comments
          $scope.note.uploaded_html_files[fileIndex].groupedComments = $scope.groupComments(data.comments)
          $scope.showNewComment(false)
          $scope.submitting = false
          $scope.newCommentText = null
        ).error( (data, status, headers, config) ->
          # TODO: error message of some sort
          $scope.submitting = false
      )

  $scope.deleteComment = (comment) ->
    comment.showDeleteConfirm = false
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
        groupedComments[i-1].comments = groupedComments[i-1].comments.concat(groupedComments[i].comments)
        groupedComments.splice(i, 1)
      else
        i++
    groupedComments
