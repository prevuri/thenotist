@NoteCtrl = ($scope, $http) ->

  $scope.comments = []

  $scope.init = (id) ->
    $scope.id = id
    $scope.getComments()

  $scope.getComments = () ->
    $http({method: 'GET', url: '/api/comments', params: {file_id: '5'}}).
      success( (data, status, headers, config) ->
        $scope.comments = data.comments
      ).error( (data, status, headers, config) ->
        # TODO: error message of some sort
    )

  $scope.submitComment = () ->
    if !$scope.submitting
      data = {
        comment: {
          text: $scope.newCommentText
        },
        file_id: "5"
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