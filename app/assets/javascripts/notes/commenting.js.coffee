Commenting = () ->
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
  
  return false

$ ->
  if $('.comments-container').length > 0
    Commenting()