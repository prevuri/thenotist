@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, $filter, UserActivityHtml, NotesApi, UserApi) ->

  $scope.init = () ->
    $scope.$root.section = 'profile'
    $scope.button = 'activity'
    if $routeParams.profileId
      $scope.userid = $routeParams.profileId
      @idParam = {id: $scope.userid}
    else
      $scope.linkToProfile = false
    $scope.getUserData($scope.userid)
    $scope.getActivityHtml()
    $scope.updateNotes()


  $scope.getActivityHtml = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      $scope.setAlert("Error retrieving user activity", false) 
    UserActivityHtml.get(@idParam, success, error)


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
          $scope.initPolling(note.id)
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesApi.get(success, error)

  $scope.getUserData = (id) ->
    success = (data) ->
      $scope.user = data.user
      $scope.$root.title = $scope.user.name
    error = (data) ->
      $scope.setAlert("Error retrieving user information", false) 
    UserApi.get(@idParam, success, error)