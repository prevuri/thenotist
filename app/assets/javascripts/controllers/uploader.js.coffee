@UploadCtrl = ($scope, $http) ->

  @statusTextDefault = "Choose file"
  @statusText2Default = ".pdf"

  $scope.modalShowing = false
  $scope.uploadShowing = false
  $scope.processingShowing = false
  $scope.controlsEnabled = true
  $scope.uploadEnabled = false

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

  $scope.init = ->
    $("#upload_form_tag").S3Uploader
      remove_completed_progress_bar: false
      allow_multiple_files: false
      click_submit_target: $('.direct-upload-submit')

    $("#upload_form_tag").bind "s3_upload_complete", (e, content) ->
      s3_key_val = $('#s3_key_tag').val()
      $http({method: 'POST', url: '/api/notes', params: {
          s3_key: s3_key_val,
          title: $scope.newNote.title,
          description: $scope.newNote.description
        }}).
        success( (data, status, headers, config) ->
          location.reload()
        )
        .error( (data, status, headers, config) ->
          $scope.handleError()
        )

    $('#upload_form_tag').bind "s3_upload_failed", (e, content) ->
      $scope.handleError()

    return false

  $scope.submitClicked = () ->
    $scope.validateUploadForm()
    if $scope.validated
      $scope.uploadShowing = true
      $scope.controlsEnabled = false
      alert "about to upload!"
      $('.direct-upload-submit').trigger('click')

  $scope.uploadAdd = (data) ->
    file = data.files[0]
    if $scope.isPdf(data)
      if !$scope.newNote.title
        $scope.newNote.title = file.name
      $scope.newNote.fileData = data
      $scope.validateUploadForm()
      $scope.updateFileName()
    else
      $scope.fileError = true
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
    $scope.typeError = $scope.isPdf($scope.newNote.fileData)
    $scope.validated = !$scope.fileError && !$scope.titleError

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

  $scope.isPdf = (fileData) ->
    type = /(\.|\/)(pdf)$/i
    file = fileData.files[0]
    return type.test(file.type) || type.test(file.name)

