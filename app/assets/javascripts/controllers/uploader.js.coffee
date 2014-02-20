@UploadCtrl = ($scope, $http) ->

  @statusTextDefault = "Choose file"
  @statusText2Default = ".pdf"

  $scope.modalShowing = false
  $scope.uploadShowing = false
  $scope.processingShowing = false
  $scope.controlsEnabled = true

  $scope.fileError = false
  $scope.titleError = false

  $scope.modified = false
  $scope.validated = false

  $scope.statusText = @statusTextDefault
  $scope.statusText2 = @statusText2Default

  $scope.progressText = ""
  $scope.progressPercent = 0

  # Form params - file, title, description
  $scope.newNote = {}

  $scope.submitClicked = () ->
    $scope.validateUploadForm()
    if $scope.validated
      $scope.uploadShowing = true
      $scope.controlsEnabled = false
      $scope.newNote.fileData.submit()

  $scope.uploadAdd = (data) ->
    types = /(\.|\/)(pdf)$/i
    file = data.files[0]
    if types.test(file.type) || types.test(file.name)
      if !$scope.newNote.title
        $scope.newNote.title = file.name
      $scope.newNote.fileData = data
      $scope.validateUploadForm()
      $scope.updateFileName()
    else
      alert("#{file.name} is not a PDF file")

  $scope.uploadProgress = (data) ->
    if (data.loaded == data.total)
      $scope.uploadShowing = false
      $scope.processingShowing = true
    else
      $scope.progressText = Math.round((data.loaded / 1000)) + "KB / " + Math.round((data.total / 1000)) + "KB"
      $scope.progressPercent = parseInt(data.loaded / data.total * 100, 10) + '%'

  $scope.uploadDone = (data) ->
    if (data.result["success"])
      $scope.setAlert("File uploaded successful. Processing may take a few minutes.", true)
      $scope.modalShowing = false
    else
      $scope.setAlert("Error uploading file.", false)

  $scope.uploadFail = (data) ->
    $scope.handleError()

  $scope.validateUploadForm = () ->
    $scope.modified = true
    $scope.fileError = !$scope.newNote.fileData || !$scope.newNote.fileData.files[0].name.length
    $scope.titleError = $.trim( $scope.newNote.title ) == ''
    $scope.validated = !$scope.fileError && !$scope.titleError
    $scope.$apply()

  $scope.updateFileName = () =>
    if $scope.newNote.fileData && $scope.newNote.fileData.files[0]
      $scope.statusText = $scope.newNote.fileData.files[0].name
      $scope.statusText2 = Math.round(($scope.newNote.fileData.files[0].size / 1000)) + "KB"
    else
      $scope.statusText = @statusTextDefault
      $scope.statusText2 = @statusText2Default

  $scope.resetUI = () ->
    $scope.uploadShowing = false
    $scope.processingShowing = false
    $scope.validated = false
    $scope.modified = false
    $scope.controlsEnabled = true
    $scope.newNote = {}
    $scope.updateFileName()

  $scope.handleError = () ->
    alert "Something went wrong, try again later."
    $scope.modalShowing = false
    $scope.resetUI()
