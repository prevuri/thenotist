@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, $filter, $timeout, UserActivityHtml, UserFriendsApi, UserApi) ->

  $scope.currentUserProfile = true
  $scope.idParam = {}

  $scope.init = () ->
    $scope.$root.section = 'profile'
    $scope.button = 'activity'
    if $routeParams.profileId && $routeParams.profileId != $scope.currentUser.id.toString()
      $scope.userid = $routeParams.profileId
      $scope.idParam = {id: $scope.userid}
      $scope.currentUserProfile = false
    else
      $scope.userid = $scope.currentUser.id
      $scope.currentUserProfile = true
      $scope.idParam = {id: $scope.userid}
    $scope.getUserData($scope.userid)
    $scope.getActivityHtml()
    $scope.getBuddies()


  $scope.getActivityHtml = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
      $timeout( () ->
        $scope.$root.loading = false
      , 100)
    error = (data) ->
      $scope.setAlert("Error retrieving user activity", false) 
    UserActivityHtml.get($scope.idParam, success, error)


  $scope.getBuddies = () ->
    success = (data) ->
      $scope.friends = $filter('orderBy')(data.friends, 'name') 
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    UserFriendsApi.get($scope.idParam, success, error)

  $scope.getUserData = (id) ->
    success = (data) ->
      $scope.user = data.user
      $scope.$root.title = $scope.user.name
    error = (data) ->
      $scope.setAlert("Error retrieving user information", false) 
    UserApi.get($scope.idParam, success, error)
