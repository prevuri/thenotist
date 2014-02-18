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

  $scope.submitComment = (id) ->
    if !$scope.submitting
      data = {
        comment: {
          text: $scope.newCommentText
        },
        file_id: id
      }
      if $scope.parentId
        data['comment']['parent_id'] = $scope.parentId
      else
        data['comment']['line_id'] = "1"

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