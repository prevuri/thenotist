@ShareCtrl = ($scope, $http, $sce, $filter, $route, NotesShareApi, NotesUnshareApi, UserFriendsApi) ->


  $scope.init = () ->

    # $scope.initializeShareModal()

  $scope.$on('shareInit', () ->
    $scope.initializeShareModal()
  )

  $scope.initializeShareModal = () ->
    success = (data) ->
      contributingIds = Array()
      nonContributingFriends = Array()

      for contrib in $scope.sharedNote.contributing_users
        contributingIds.push(contrib.id)

      for friend in data.friends
        if friend.id not in contributingIds
          nonContributingFriends.push(friend)
      $scope.friends = $filter('orderBy')(nonContributingFriends, 'name')
      $('.search-friend-box .form-control').focus()
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    UserFriendsApi.get({id: $scope.currentUser.id}, success, error)

  $scope.hideShareModal = () ->
    $('.share-note-form-container').modal('hide')

  $scope.shareNote = (user) ->
    post_data = {
      id: $scope.sharedNote.id,
      userid: user.id
    }
    success = (data) ->
      userIn = $scope.friends.indexOf(user)
      $scope.friends.splice(userIn, 1)
      $scope.sharedNote.contributing_users.push(user)
      if $route.current.controller == "NotesCtrl"
        $scope.searchFriends = ""
        $scope.$parent.updateNotes()
    error = (data) ->
      $scope.setAlert("Error sharing the note", false)
    NotesShareApi.share({}, post_data, success, error)

  $scope.unshareNote = (user) ->
    post_data = {
      id: $scope.sharedNote.id,
      userid: user.id
    }
    success = (data) ->
      userIn = $scope.sharedNote.contributing_users.indexOf(user)
      $scope.sharedNote.contributing_users.splice(userIn, 1)
      $scope.friends.push(user)
      if $route.current.controller == "NotesCtrl"
        $scope.searchFriends = ""
        $scope.$parent.updateNotes()
    error = (data) ->
      $scope.setAlert("Error sharing the note", false)
    NotesUnshareApi.remove({}, post_data, success, error)
