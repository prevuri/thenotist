Commenting = () ->
  # COMMENTING


  @orderComments = () =>
    @commentContainers = $('.comments-container')
    for commentContainer in @commentContainers
      $(commentContainer).css('top', $(commentContainer).parents('.page').find('.page-container').offset().top - 105)

    @commentButtons = $('.comment-button[line_id]')
    for commentButton in @commentButtons
      lineId = $(commentButton).attr("line_id")
      topCss = $('[data-guid='+lineId+']').offset().top - $('.file-container').offset().top
      commentBox = $('.comment[line_id='+lineId+']')
      $(commentButton).css('top', topCss)
      $(commentBox).parents('.comment-thread-container').css('top', topCss - 20)

  
  $(window).load( ()->
    @orderComments())

  $('.note-page .t, .note-page .bi').click (e) =>
    @lineClick(e)

  $('.note-page .t, .note-page .bi').hover (e) =>
    # show comment button ghost

  $('body').on "click", ".reply-button", (e) =>
    @replyClick(e)

  $('.new-comment-submit').click ->
    if !$(this).hasClass('disabled') 
      $(this).addClass('disabled')
      @selector = $(this).parents('.comment-inner')
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
      @commentText = $(selector).find('#newcomment').val()
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
      data['comment']['line_id'] = @line_id

    @submitting = true
    $.post('/api/comments', data, (response) =>
      if !response.success
        alert response.error
      else
        @hideNewCommentField()
        $(@fileButtonContainer).html(" ").html(response['comment_buttons_html'] )
        $(@fileComments).html(" ").html( response['comments_html'] )
        @orderComments()

      @submitting = false
    )


  @setCommentPanelPositionReply = (yCoord) =>
    $(@fileCommentContainer).children('#new-comment-panel').css('top', yCoord + 'px')

  @setCommentPanelPositionClick = (yClick) =>
    $(@fileCommentContainer).children('#new-comment-panel').css('top', yClick + 'px')

  @showNewCommentFieldParent = () =>
    @newCommentShowing = true 
    $('.comment #new-comment-panel').removeClass('reply').addClass('parent')
    $(@fileCommentContainer).children('#new-comment-panel').show();
    @showNewCommentField(@fileCommentContainer)

  @showNewCommentFieldReply = () =>
    @newCommentShowing = true 
    $('.comment #new-comment-panel').removeClass('parent').addClass('reply')
    $(@fileCommentContainer).children('#new-comment-panel').hide();
    @showNewCommentField(@fileCommentContainer)

  @showNewCommentField = () =>
    $(@fileCommentContainer).children('#new-comment-panel').show(200, () ->
      $(@fileCommentContainer).children('#newcomment').focus()
    )

  @hideNewCommentField = () =>
    @newCommentShowing = false
    $(@fileCommentContainer).children('#new-comment-panel').hide(200, () ->
      $('#new-comment-panel .new-comment-submit').removeClass('disabled')
      $('.comment-inner #newcomment').val('')
    )

  @hideAllCommentField = () =>
    @newCommentShowing = false
    $('.comment #new-comment-panel').hide( () ->
      $('.comment #new-comment-submit').removeClass('disabled')
      $('.comment-inner #newcomment').val('')
    )



  @lineClick = (e) =>
    if !@submitting
      @line = if ($(e.target).hasClass('t') || $(e.target).hasClass('bi')) then $(e.target) else $(e.target).parents('.t, .bi')
      @notePage = @line.parents('.page')
      @fileContainer = @line.parents('.file-container')
      @yCoord = @line.offset().top - @fileContainer.offset().top - 10

      @line_id = @line.attr('data-guid')
      @fileId = @line.parents('.note-page').attr('file-id')
      
      @fileComments = @notePage.find('.comments')
      @fileButtonContainer = @notePage.find('.comment-buttons-container')
      @fileCommentContainer = @notePage.find('.comments-container')
      @setCommentPanelPositionClick(@yCoord)
      if !@newCommentShowing
        @showNewCommentFieldParent()
      else
        @hideAllCommentField()
        @showNewCommentFieldParent()

    # @lineHover = (e) =>
    #   if !@submitting


  @replyClick = (e) =>

    parentComment = $(e.target).parents('.comment')[0]
    @fileComments = $(e.target).parents('.comments')
    @fileCommentContainer = $(e.target).parents('.comments-container')

    commentThreadContainer = $(e.target).parents('.comment-thread-container')

    @setCommentPanelPositionReply($(parentComment).offset().top + $(commentThreadContainer).height() + 10 - @fileCommentContainer.offset().top)
    @parentId = $(parentComment).attr('comment-id')
  
    # @line_id = @line.attr('data-guid')
    @fileId = $(parentComment).attr('file-id')
  
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
    @activeCommentLineId = $(commentButton).parents('.comment-button').attr('line_id')
    @newActiveComment = $('.comment.parent[line_id='+@activeCommentLineId+']')
    if @activeComment
      $(@activeComment).hide(200)
      $(@activeCommentButton).removeClass('active')
    if $(@activeComment).attr('comment-id') != $(@newActiveComment).attr('comment-id')
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

    elementButton = element
    if $(element).hasClass('parent')
      # If comment is parent, remove while thread, not just comment
      elementButton = $('.comment-button[line_id='+$(element).attr('line_id')+']')
      element = $(element).parents('.comment-thread-container') 
    $(element).hide(200, () ->
      $(element).remove()
      $(elementButton).remove()
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