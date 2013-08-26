Commenting = () ->
  # COMMENTING
  $('.note-image').click (e) =>
    @yCoordClick(e)

  $('body').on "click", ".reply-button", (e) =>
    commentDiv = $(e.target).parents('.comment')[0]
    @fileComments = $(e.target).parents('.comments')  
    @fileCommentContainer = $(e.target).parents('.comments-container')
    @setCommentPanelPositionReply(commentDiv.offsetTop + commentDiv.clientHeight + 10)
    @parentId = $(commentDiv).attr('comment-id')
    @fileId = $(commentDiv).attr('file-id')
    @replyClick(@fileCommentContainer)

  $('.tooltip #new-comment-submit').click ->
    if !$(this).hasClass('disabled') 
      $(this).addClass('disabled')
      @selector = $(this).parents('.tooltip-inner')
      _this.submitComment(@selector)

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

  $('body').on "click", ".comment-button", (e) =>
    @showComment(e.target)

  @submitComment = () ->
  @submitComment = (selector) ->
    if !@submitting
      @commentText = $(selector).children('#newcomment').val()
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
        $(@fileComments).html(" ").html( response['comments_html'] )
        @hideNewCommentField()

      submitting = false
    )

  @setCommentPanelPositionReply = (yCoord) =>
    $(@fileCommentContainer).children('#new-comment-panel').css('top', yCoord + 'px')

  @setCommentPanelPositionClick = (yClick) =>
    $(@fileCommentContainer).children('#new-comment-panel').css('top', (yClick - 150 + 25) + 'px')

  @showNewCommentFieldParent = () =>
    @newCommentShowing = true 
    $(@fileCommentContainer).children('#new-comment-panel .tooltip-arrow').show();
    @showNewCommentField(@fileCommentContainer)

  @showNewCommentFieldReply = () =>
    @newCommentShowing = true 
    $(@fileCommentContainer).children('#new-comment-panel .tooltip-arrow').hide();
    @showNewCommentField(@fileCommentContainer)

  @showNewCommentField = () =>
    $(@fileCommentContainer).children('#new-comment-panel').show(200, () ->
      $(@fileCommentContainer).children('#newcomment').focus()
    )
    $('#new-comment-position-line').show(200)

  @hideNewCommentField = () =>
    @newCommentShowing = false
    $(@fileCommentContainer).children('.tooltip #new-comment-position-line').hide(200)
    $(@fileCommentContainer).children('.tooltip').hide(200, () ->
      $('.tooltip #new-comment-submit').removeClass('disabled')
      $('.tooltip #newcomment').val('')
    )

  @hideAllCommentField = () =>
    @newCommentShowing = false
    $('.tooltip #new-comment-position-line').hide()
    $('.tooltip').hide( () ->
      $('.tooltip #new-comment-submit').removeClass('disabled')
      $('.tooltip #newcomment').val('')
    )

  @yCoordClick = (e) =>
    if !@submitting
      @yCoord = e.pageY - $(e.target).offset().top
      @parentId = null
      @fileId = $(e.target).attr('file-id')
      @fileComments = $(e.target).parents('.file-container').find('.comments')
      @fileCommentContainer = $(e.target).parents('.file-container').find('.comments-container')
      @setCommentPanelPositionClick(@yCoord)
      if !@newCommentShowing
        @showNewCommentFieldParent()
      else if !@fileCommentContainer.children('#new-comment-panel').is(':visible')
        @hideAllCommentField()
        @showNewCommentFieldParent()

  @replyClick = () =>
    if !@newCommentShowing
        @showNewCommentFieldReply()
      else if !$(@fileCommentContainer).children('#new-comment-panel').is(':visible')
        @hideAllCommentField()
        @showNewCommentFieldReply()

  @setActive = (clickedComment) ->
    if (@activeComment)
      $(@activeComment).removeClass('active')

    if (clickedComment != @activeComment)
      @activeComment = clickedComment
      $(@activeComment).addClass('active')
    else
      @activeComment = null;

  @showComment = (commentButton) =>
    @newActiveComment = $(commentButton).parents('.comment-thread-container').children('.comment.parent')[0]
    if @activeComment
      $(@activeComment).hide(200)
      $(@activeCommentButton).removeClass('active')
    if @activeComment != @newActiveComment
      @activeComment = @newActiveComment
      $(@activeComment).show(200)
      @activeCommentButton = commentButton
      $(@activeCommentButton).addClass('active')
    else
      @activeComment = null
      @activeCommentButton = null

  @deleteClicked = (e) =>
    $(e.target).fadeOut(150)
    @showDeleteConfirmation($(e.target).parents('.comment')[0])
    return false

  @showDeleteConfirmation = (element) ->
    $(element).find('.delete-confirm-panel').first().show(150)
    @deletingCommentElement = element

  @deleteComment = () ->

    element = @deletingCommentElement

    id = $(element).attr('comment-id')

    $.ajax
      url: '/api/comments/' + id,
      type: 'DELETE',
      error: (response) ->
        alert response.error

    if $(element).hasClass('parent')
      # If comment is parent, remove while thread, not just comment
      element = $(element).parents('.comment-thread-container') 
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