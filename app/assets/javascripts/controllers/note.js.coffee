@NoteCtrl = ($scope, $http) ->

  $scope.files = []

  $scope.init = (id) ->
    $scope.id = id
    # $scope.getComments()

  $scope.getComments = (id) ->
    $scope.files[id] = {}
    $http({method: 'GET', url: '/api/comments', params: {file_id: id}}).
      success( (data, status, headers, config) ->
        $scope.files[id].comments = data.comments
      ).error( (data, status, headers, config) ->
        # TODO: error message of some sort
    )

  $scope.newComment = (lineId) ->
    $scope.newCommentLineId = lineId
    $scope.parentId = null
    $scope.showNewComment = true

  $scope.newCommentClick = (event, fileId) ->
    $scope.newCommentY = event.pageY
    $scope.newCommentFileId = fileId

  $scope.commentY = (lineId) ->
    $('[data-guid='+lineId+']').position().top

  $scope.canReply = (comment) ->
    comment.parent_comment_id == null

  $scope.expandCommentLine = (lineId) ->
    $scope.expandedCommentLine = if $scope.expandedCommentLine == lineId then null else lineId

  $scope.submitParentComment = () ->
    $scope.submitComment($scope.newCommentText, $scope.newCommentFileId, null)

  $scope.submitReply = (parentComment, fileId) ->
    $scope.submitComment(parentComment.newReplyText, fileId, parentComment.id)

  $scope.submitComment = (text, fileId, parentId) ->
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
          $scope.files[fileId].comments = data.comments
          $scope.showNewComment = false
          $scope.submitting = false
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
          alert('Error deleting comment')
          comment.deleteFade = false
      )