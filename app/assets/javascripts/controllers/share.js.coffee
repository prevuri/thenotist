@ShareCtrl = ($scope, $http, $sce, $filter, NotesShareApi, UserFriendsApi) ->

  $scope.init = () ->
    $scope.initializeDropdown()



  $scope.initializeDropdown = () ->
    $scope.shareForm = $('.share-note-form-container').find('.form')
    success = (data) ->
      $scope.friends = $filter('orderBy')(data.friends, 'name')
      $scope.msForm = $($scope.shareForm).magicSuggest({
        width: 530,
        height: 200,
        toggleOnClick: true,
        emptyText: 'Search for friends or groups to share note with!'
        data: $.map($scope.friends, (value, key) =>
          return {
            id: value.id,
            name: value.name,
            image: value.image
          }),
        renderer: (v) =>
          return '<div>' +
            '<div style="float:left;"><img class="profile-image circular" style="width:50px;height:50px"src="' + v.image + '"/></div>' +
            '<div style="padding-left: 85px;">' +
                '<div style="padding-top: 20px;font-style:bold;font-size:120%;color:#333">' + v.name + '</div>' +
                '</div>' +
            '</div><div style="clear:both;"></div>';
        })
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    UserFriendsApi.get({id: $scope.currentUser.id}, success, error)

  $scope.hideShareModal = () ->
    $('.share-note-form-container').modal('hide')

  $scope.shareNote = () ->
    shareIds = $('.share-note-form-container').find('#ms-sel-ctn-0 input[type=hidden]').val()
    post_data = {
      id: $scope.sharedNote.id,
      userids: shareIds
    }
    success = (data) ->
      $scope.$parent.updateNotes()
      $scope.hideShareModal()
    error = (data) ->
      $scope.setAlert("Error loading friends list", false)
    NotesShareApi.share({}, post_data, success, error)
