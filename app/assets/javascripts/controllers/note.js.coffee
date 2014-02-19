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
    $scope.lineId = lineId

  $scope.newCommentClick = (event) ->
    $scope.newCommentY = event.pageY
    $scope.showNewComment = true

  $scope.submitComment = () ->
    if !$scope.submitting
      data = {
        comment: {
          text: $scope.newCommentText
        }
      }
      if $scope.parentId
        data['comment']['parent_id'] = $scope.parentId
      else
        data['comment']['line_id'] = $scope.lineId

      $scope.submitting = true
      $http({method: 'POST', url: '/api/comments', data: data}).
        success( (data, status, headers, config) ->
          $scope.comments = data.comments
          $scope.showNewComment = false
          $scope.submitting = false
        ).error( (data, status, headers, config) ->
          # TODO: error message of some sort
          $scope.submitting = false
      )