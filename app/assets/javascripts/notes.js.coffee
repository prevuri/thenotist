# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # FILE UPLOAD FUNCTIONALITY
  upload_data = 0

  @showOverlay = () =>
    $('.full-screen-overlay').show()

  @hideOverlay = () =>
    $('.full-screen-overlay').hide()

  @showUploadProgress = () =>
    file_name = upload_data.files[0].name || "file"
    $('.activity-label').html("Uploading " + file_name + " ...")
    $('.activity-label.secondary').html("Do not refresh this page")
    $('.upload-progress').show()

  @hideUploadProgress = () => 
    $('.upload-progress').hide()

  @showSpinner = () =>
    file_name = ""
    file_name = upload_data.files[0].name if upload_data
    $('.processing-container').show()
    $('.activity-label').html("Processing " + file_name + " ...")
    $('.activity-label.secondary').html("You will be automatically redirected to your note when the file is processed.")
    $('.processing-container').spin
      lines: 7,
      length: 0,
      width: 20,
      radius: 24,
      corners: 1.0,
      trail: 77,
      speed: 1.2,
      shadow: true,
      color: '#fff'

  @hideSpinner = () =>
    $('.processing-container').hide()
  
  @handleError = () =>
    alert "Something went wrong, try again later."
    @hideOverlay()
    upload_data = 0
    location.reload()

  $('.select-file').click =>
    $('#file-picker').click()

  $('.submit-action').click =>
    if upload_data
      @showOverlay()
      @showUploadProgress()
      upload_data.submit()

  $('.new-file-upload').fileupload
    dataType: 'json'
    add: (e, data) =>
      types = /(\.|\/)(pdf)$/i
      file = data.files[0]
      inter = $('.upload-interaction')
      if types.test(file.type) || types.test(file.name)
        inter.find('.file-name').html file.name
        if !$('#note-title-field').val()
          $('#note-title-field').val(file.name)
        inter.find('.file-size').html((file.size / 1000) + "KB")
        upload_data = data
      else
        alert("#{file.name} is not a PDF file")

    progress: (e, data) =>
      if (data.loaded == data.total)
        @hideUploadProgress()
        @showSpinner()
      else
        inter = $('.upload-interaction')
        inter.find('.upload-progress-text').html((data.loaded / 1000) + "KB / " + (data.total / 1000) + "KB")
        progress = parseInt(data.loaded / data.total * 100, 10)
        inter.find('.bar').css('width', progress + '%')

    done: (e, data) =>
      if (data.result["success"])
        document.location.href = data.result["uri"]
        upload_data = 0 # clear the file
      else
        @handleError()

    fail: (e, data) =>
      @handleError()

  # COMMENTING
  @submitComment = (fileId) =>
    commentText = $('#newcomment').val()
    ycoord = $('#ycoord').val()

    data = {
      comment: {
        text: commentText,
        ycoord: ycoord
      },
      file_id: fileId
    }

    $.post('/api/comments', data, (response) ->
      if !response.success
        alert response.error
      else
        alert "Success!"
    )

  @setActive = (clickedComment) ->
    if (@activeComment)
      $(@activeComment).removeClass('active')

    if (clickedComment != @activeComment)
      @activeComment = clickedComment
      $(@activeComment).addClass('active')
    else
      @activeComment = null;
