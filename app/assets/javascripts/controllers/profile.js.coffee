@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, UserActivityHtml, UserApi) ->

  $scope.init = () ->
    if $routeParams.profileId
      id = $routeParams.profileId
      @idParam = {id: id}
    else
      $scope.linkToProfile = false
    $scope.getUserData(id)
    $scope.getActivityHtml()

  $scope.getActivityHtml = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      $scope.setAlert("Error retrieving user activity", false) 
    UserActivityHtml.get(@idParam, success, error)

  $scope.getUserData = (id) ->
    success = (data) ->
      $scope.user = data.user
    error = (data) ->
      $scope.setAlert("Error retrieving user information", false) 
    UserApi.get(@idParam, success, error)