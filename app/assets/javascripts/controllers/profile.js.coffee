@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, $filter, UserActivityHtml, UserFriendsApi, NotesApi, NotesUserApi, UserApi) ->

  $scope.init = () ->
    $scope.$root.section = 'profile'
    $scope.button = 'activity'
    if $routeParams.profileId
      $scope.userid = $routeParams.profileId
      @idParam = {id: $scope.userid}
      $scope.userNotes()
    else
      $scope.userid = $scope.currentUser.id
      @idParam = {id: $scope.userid}
      $scope.updateNotes()
    $scope.getUserData($scope.userid)
    $scope.getActivityHtml()
    $scope.getBuddies()


  $scope.getActivityHtml = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      $scope.setAlert("Error retrieving user activity", false) 
    UserActivityHtml.get(@idParam, success, error)


  $scope.getBuddies = () ->
    success = (data) ->
      $scope.friends = $filter('orderBy')(data.friends, 'name') 
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    UserFriendsApi.get(@idParam, success, error)

  # Updates all the notes on the page
  $scope.updateNotes = () ->
    success = (data) ->
      $scope.notes = $filter('orderBy')(data.notes, 'created_at', true)
      for note in $scope.notes
        if note.user.id == $scope.currentUser.id
          note.shared = false
        else
          note.shared = true
        if !note.processed
          $scope.notesProcessing.push note.id
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesApi.get(success, error)

  $scope.userNotes = () ->
    success = (data) ->
      $scope.notes = $filter('orderBy')(data.notes, 'created_at', true)
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesUserApi.get(@idParam, success, error)

  $scope.getUserData = (id) ->
    success = (data) ->
      $scope.user = data.user
      $scope.$root.title = $scope.user.name
    error = (data) ->
      $scope.setAlert("Error retrieving user information", false) 
    UserApi.get(@idParam, success, error)