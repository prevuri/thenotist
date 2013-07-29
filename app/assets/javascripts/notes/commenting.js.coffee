Commenting = () ->
  # COMMENTING
  $('.note-image').click (e) =>
    @yCoordClick(e)

  $('body').on "click", ".reply-button", (e) =>
    commentDiv = $(e.target).parents('.comment')[0]
    @fileCommentContainer = $(e.target).parents('.comments-container')
    @setCommentPanelPositionReply(commentDiv.offsetTop + commentDiv.clientHeight + 10)
    @parentId = $(commentDiv).attr('comment-id')
    @fileId = $(commentDiv).attr('file-id')
    @replyClick()

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
        text: @commentText
      },
      file_id: @fileId
    }

    if @parentId
      data['comment']['parent_id'] = @parentId
    else
      data['comment']['ycoord'] = @yCoord

    submitting = true
    $.post('/api/comments', data, (response) =>
      if !response.success
        alert response.error
      else
        $(@fileCommentContainer).html( response['comments_html'] )
        @hideNewCommentField()

      submitting = false
    )

  @setCommentPanelPositionReply = (yCoord) =>
    $('#new-comment-panel').css('top', yCoord + 'px')

  @setCommentPanelPositionClick = (yClick) =>
    $('#new-comment-panel').css('top', (yClick - 150 + 25) + 'px')

  @showNewCommentFieldParent = () =>
    @newCommentShowing = true
    $('#new-comment-panel .left-arrow').show();
    @showNewCommentField()

  @showNewCommentFieldReply = () =>
    $('#new-comment-panel .left-arrow').hide();
    @showNewCommentField()

  @showNewCommentField = () =>
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
      @parentId = null
      @fileId = $(e.target).attr('file-id')
      @fileCommentContainer = $(e.target).parents('.file-container').find('.comments-container')
      @setCommentPanelPositionClick(e.pageY)
      if !@newCommentShowing
        @showNewCommentFieldParent()

  @replyClick = () ->
    @showNewCommentFieldReply()

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
    @showDeleteConfirmation($(e.target).parents('.comment-inner'))
    return false

  @showDeleteConfirmation = (element) ->
    $(element).find('.delete-confirm-panel').show(150)
    @deletingCommentElement = $(element).parent()

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
      $(element + ' + .reply').remove()
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