@NotesCtrl = ($scope, $http, NotesApi) ->

  $scope.overview = {
    'images': '',
    'showing': false
  }

  $scope.init = () ->
    success = (data) ->
      $scope.notes = data.notes
    error = (data) ->
      alert(data) 
    NotesApi.get(success, error)

  $scope.deleteNote = (note, index) ->
    success = (data) ->
      $scope.notes.splice(index, 1)
    error = (data) ->
      alert(data) 
    NotesApi.delete({id: note.id}, success, error)

  $scope.$on('escapePressed', () ->
    $scope.hideOverview()
  )

  $scope.showOverview = (url) ->
    $http({method: 'GET', url: url}).
      success( (data, status, headers, config) ->
        $scope.overview.images = []
        $scope.overview.urls = []
        for page in data.note.uploaded_html_files
          imageObject = {
            'src': page.thumb_url,
            'pageUrl': "/notes/" + data.note.id + "#Page-" + page.page_number
          }
          $scope.overview.images.push imageObject
      ).error( (data, status, headers, config) ->
        # TODO: error message of some sort
    )
    $scope.overview.showing = true

  $scope.hideOverview = () ->
    $scope.overview.showing = false
    $scope.overview.images = []
