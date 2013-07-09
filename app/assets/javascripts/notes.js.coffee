# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->

  # GENERAL NOTE UI
  $('.notes-list-item').hover \
        (-> $(this).find('.btn-group').removeClass('hidden').fadeIn(150)), \
        (-> 
          $(this).find('.btn-group').addClass('hidden').fadeOut(150)
          $(this).find('.tooltip').addClass('hidden').fadeOut(150))

  # FILE UPLOAD FUNCTIONALITY
  upload_data = 0
  overview_mode = false;

  @showOverlay = () =>
    $('.full-screen-overlay').fadeIn(200)
    overview_mode = true;

  @hideOverlay = () =>
    $('.full-screen-overlay').fadeOut(200)
    overview_mode = false;

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

  $('#note-title-field').focus( () ->
    $('#title-field').removeClass('error')
  )

  $('.select-file').click =>
    $('.select-file').removeClass('error')
    $('#file-picker').click()

  @validateUploadForm = () ->
    result = true
    if (!upload_data || !upload_data.files[0].name.length)
      $('.select-file').addClass('error')
      result = false
    if ($.trim( $('#note-title-field').val() ) == '')
      $('#title-field').addClass('error')
      result = false
    return result

  $('.submit-action').click =>
    if @validateUploadForm()
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
          $('#title-field').removeClass('error')

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


  #SHARING
  $('.share-note').click (e) =>
    @shareClick(e)

  @shareWithUser = (event, ui, note_id) =>
    $('.tooltip').addClass("hidden", 1000)
    data = {
      id: note_id,
      userid: ui.item.id
    }
    $.post('/api/notes/share', data, (response) =>
      if !response.success
        alert response.error
    )

  @shareClick = (e) =>
    $.get('/api/buddies', (response) =>
      $('#buddies').autocomplete
        source: $.map(response, (value, key) =>
          return {
            label: value,
            value: value,
            id: key
          }),
        select: (event, ui) =>
          @shareWithUser(event, ui, e.target.getAttribute("note_id"))
# <<<<<<< HEAD
    )
    $(e.target).parents('.note-item').children('#list-footer').children('.tooltip').toggleClass("hidden", 1000)
# =======
#       });
#     )
#     $('#buddies').toggleClass("hidden")


# >>>>>>> note-overview-page
  # COMMENTING
  $('.note-image').click (e) =>
    @yCoordClick(e)

  $('#new-comment-submit').click ->
    if !$(this).hasClass('disabled') 
      $(this).addClass('disabled')
      _this.submitComment()

  $('body').on "click", ".comment", (e) ->
    _this.setActive(this);

  $('.new-comment-cancel').click =>
    @hideNewCommentField()

  $('body').on "click", ".delete-button", (e) =>
    @deleteClicked(e)

  $('body').on "click", ".delete-cancel", (e) =>
    @deleteCancelClicked()

  $('body').on "click", ".delete-confirm", (e) =>
    @deleteComment()

  @submitComment = () ->
    if !@submitting
      @commentText = $('#newcomment').val()
      @makeNewCommentRequest()

  @makeNewCommentRequest = () =>
    data = {
      comment: {
        text: @commentText,
        ycoord: @yCoord
      },
      file_id: @fileId
    }

    submitting = true
    $.post('/api/comments', data, (response) =>
      if !response.success
        alert response.error
      else
        $(@fileCommentContainer).html( response['comments_html'] )
        @hideNewCommentField()

      submitting = false
    )

  @setCommentPanelPosition = (yClick) =>
    $('#new-comment-panel').css('top', (yClick - 150 + 25) + 'px')

  @showNewCommentField = () =>
    @newCommentShowing = true
    $('#new-comment-panel').show(200, () ->
      $('#newcomment').focus()
    )
    $('#new-comment-position-line').show(200)

  @hideNewCommentField = () =>
    @newCommentShowing = false
    $('#new-comment-position-line').hide(200)
    $('#new-comment-panel').hide(200, () ->
      $('#new-comment-submit').removeClass('disabled')
      $('#newcomment').val('')
    )

  @yCoordClick = (e) ->
    if !@submitting
      @yCoord = e.offsetY
      @fileId = $(e.target).attr('file-id')
      @fileCommentContainer = $(e.target).parents('.file-container').find('.comments-container')
      @setCommentPanelPosition(e.pageY)
      if !@newCommentShowing
        @showNewCommentField()

  @setActive = (clickedComment) ->
    if (@activeComment)
      $(@activeComment).removeClass('active')

    if (clickedComment != @activeComment)
      @activeComment = clickedComment
      $(@activeComment).addClass('active')
    else
      @activeComment = null;

  @deleteClicked = (e) =>
    $(e.target).fadeOut(150)
    element = e.target
    while (! $(element).hasClass('comment'))
      element = $(element).parent()
    @showDeleteConfirmation(element)
    return false

  @showDeleteConfirmation = (element) ->
    $(element).find('.delete-confirm-panel').show(150)
    @deletingCommentElement = element

  @deleteComment = () ->

    element = @deletingCommentElement

    id = $(element).attr('comment-id')

    $.ajax
      url: '/api/comments/' + id,
      type: 'DELETE',
      error: (response) ->
        alert response.error

    $(element).hide(200, () ->
      $(element).remove()
    )

    return false  # Stop comment click action from happening

  @deleteCancelClicked = () ->
    element = @deletingCommentElement
    $(element).find('.delete-confirm-panel').hide(150)
    $(element).find('.delete-button').fadeIn(150)
    return false




  # OVERVIEW PAGE FUNCTIONALITY
  overview_mode = false;

  $('.overview-btn').click () ->
    $('.modal-container-container').show()
    $('.modal-container').show()
    $('.full-screen-overlay').fadeIn(200)
    overview_mode = true;

    path = $(this).attr('data-path')
    $.get(path, (response) ->
      if !response.success
        alert response.error
      else
        for page in response.note.uploaded_files
          url = "/notes/" + response.note.id + "#Page-" + page.page_number
          image_container = $('.template.thumb-container').clone()
          image_container.removeClass('template')
          image = image_container.find('img')
          $(image).attr('src', page.thumb_url)
          $(image).attr('data-path',url)

          $('.modal-container').append(image_container)

        pageCount = response.note.uploaded_files.length
        thumbWidth = 240
        if pageCount < 5
          leftMargin = (documentWidth/2) - (thumbWidth/2)*pageCount
          modal_container.css("margin-left",leftMargin+"px")
    )

  @clearOverviewPage = () =>
    $('.modal-container').empty()

  $('body').keyup (e) =>
    if (e.keyCode == 27 && overview_mode) # escape
      # user has pressed space
      @clearOverviewPage()
      $('.modal-container-container').hide()
      $('.full-screen-overlay').hide()

  $('body').on "click", ".thumb-image", (e) ->
    window.location = $(this).attr("data-path")

  $('body').on "click", ".modal-container-container", (e) =>
    @clearOverviewPage()
    $('.modal-container-container').hide()
    $('.full-screen-overlay').hide()

  return false
