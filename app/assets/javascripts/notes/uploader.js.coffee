Uploader = () ->
  # FILE UPLOAD FUNCTIONALITY
  upload_data = 0

  @hideModal = () ->
    $('.new-note-form-container').modal('hide')

  @showUploading = () =>
    $('.upload-progress').show()
    $('.submit-action-icon').hide()
    $('.submit-action-text').html "Uploading ..."

  @hideUploadProgress = () =>
    $('.upload-progress').hide()

  @showProcessing = () =>
    $('.upload-progress').hide()
    $('.processing-label').show()
    $('.spinner-container').show()
    $('.submit-action-icon').hide()
    $('.submit-action-text').html "Processing file ..."
    @showSpinner()

  @hideProcessing = () =>
    $('.processing-label').hide()
    $('.spinner-container').hide()

  @showSpinner = () =>
    file_name = ""
    file_name = upload_data.files[0].name if upload_data
    $('.spinner-container').spin
      lines: 7,
      length: 0,
      width: 5,
      radius: 10,
      corners: 1.0,
      trail: 50,
      speed: 1.2,
      shadow: false,
      color: '#a6a6a6'
    

  @resetUI = () =>
    @hideUploadProgress()
    @hideProcessing()
    @enableUploadControls()
    $('.submit-action-icon').show()
    $('.submit-action-text').html "Upload"
    upload_data = 0
    @updateFileName()
    $('#upload_form_tag')[0].reset()
    @validateUploadForm()

  @handleError = () =>
    alert "Something went wrong, try again later."
    @hideModal()
    @resetUI()

  @validateUploadForm = () ->
    result = true
    if (!upload_data || !upload_data.files[0].name.length)
      $('.select-file').addClass('error')
      $('.select-file').removeClass('success')
      $('.error-icon').show()
      $('.success-icon').hide()
      result = false
    else
      $('.select-file').removeClass('error')
      $('.select-file').addClass('success')
      $('.error-icon').hide()
      $('.success-icon').show()

    if ($.trim( $('#note-title-field').val() ) == '')
      $('#title-field').addClass('error')
      $('#title-field').removeClass('success')
      $('.error-icon').show()
      $('.success-icon').hide()
      result = false
    else
      $('#title-field').addClass('success')
      $('#title-field').removeClass('error')
      $('.error-icon').hide()
      $('.success-icon').show()
    return result

  @updateFileName = () =>
    if upload_data && upload_data.files[0]
      $('.select-file .upload-status-icon').removeClass("icon-plus")
      $('.select-file .upload-status-icon').addClass("icon-file-alt")
      $('.select-file .upload-status-text').html upload_data.files[0].name
      $('.select-file .upload-status-text-secondary').html Math.round((upload_data.files[0].size / 1000)) + "KB"
    else
      $('.select-file .upload-status-icon').removeClass("icon-file-alt")
      $('.select-file .upload-status-icon').addClass("icon-plus")
      $('.select-file .upload-status-text').html "Choose file"
      $('.select-file .upload-status-text-secondary').html ".pdf"

  @disableUploadControls = () =>
    $('.select-file').addClass "disabled"
    $('.submit-action').addClass "disabled"
    $('#note-title-field').attr "disabled", "disabled"
    $('#note-description-field').attr "disabled", "disabled"

  @enableUploadControls = () =>
    $('.select-file').removeClass "disabled"
    $('.submit-action').removeClass "disabled"
    $('#note-title-field').removeAttr "disabled"
    $('#note-description-field').removeAttr "disabled"

  $('#note-title-field').keyup () =>
    @validateUploadForm()

  $('.select-file').click =>
    if !$('.select-file').hasClass("disabled")
      $('#file-picker').click()

  $('.submit-action').click =>
    if !$('.submit-action').hasClass("disabled") && @validateUploadForm()
      @showUploading()
      upload_data.submit()
      @disableUploadControls()

  $('.new-file-upload').fileupload
    dataType: 'json'
    add: (e, data) =>
      types = /(\.|\/)(pdf)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        if !$('#note-title-field').val()
          $('#note-title-field').val(file.name)
        upload_data = data
        @validateUploadForm()
        @updateFileName()
      else
        alert("#{file.name} is not a PDF file")

    progress: (e, data) =>
      if (data.loaded == data.total)
        @hideUploadProgress()
        @showProcessing()
      else
        parent = $('.upload-progress')
        parent.find('.upload-progress-text').html(Math.round((data.loaded / 1000)) + "KB / " + Math.round((data.total / 1000)) + "KB")
        progressValue = parseInt(data.loaded / data.total * 100, 10)
        parent.find('.bar').css('width', progressValue + '%')

    done: (e, data) =>
      if (data.result["success"])
        alert "Your data is being processed. This can take a few minutes. Don't worry, we'll let you know when it's done."
        @hideModal()
        location.reload()
      else
        @handleError()

    fail: (e, data) =>
      @handleError()
  
  return false

$ ->
  if $('.create-new-note-container').length > 0
    Uploader()