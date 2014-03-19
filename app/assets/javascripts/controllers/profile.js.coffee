@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, $filter, $timeout, UserActivityHtml, UserFriendsApi, UserApi) ->

  $scope.init = () ->
    $scope.$root.section = 'profile'
    if $routeParams.profileId && $routeParams.profileId != $scope.currentUser.id.toString()
      $scope.button = 'notes'
      $scope.userId = $routeParams.profileId
    else
      $scope.button = 'buddies'
      $scope.userId = $scope.currentUser.id
    $scope.getUserData()
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
    UserActivityHtml.get({id: $scope.userId}, success, error)

  $scope.getBuddies = () ->
    success = (data) ->
      $scope.friends = $filter('orderBy')(data.friends, 'name')
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    UserFriendsApi.get({id: $scope.userId}, success, error)

  $scope.getUserData = () ->
    success = (data) ->
      $scope.user = data.user
      $scope.$root.title = $scope.user.name
    error = (data) ->
      $scope.setAlert("Error retrieving user information", false)
    UserApi.get({id: $scope.userId}, success, error)
