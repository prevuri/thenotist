# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.note-images').click( (e) ->
    yCoordClick(e)
  )
  $('#new-comment-submit').click( () ->
    submitComment( $('#new-comment-submit').attr('file-id') )
  )
  $('.comment').click( () ->
    setActive(this);
    scrollNoteToYCoord( $(this).attr('ycoord') )
  )
  $('#upload-form').submit( (e) ->
    validateUploadForm()
  )
  $('#notes_title').focus( () ->
    $('#title-field').removeClass('error')
  )
  $('#notes_file').click( () ->
    $('#upload-label').removeClass('error')
  )
  $('.new-comment-cancel').click( () ->
    hideNewCommentField()
  )
  $('.delete-button').click( (e) ->
    deleteClicked(e)
  )
  $('.delete-cancel').click( () ->
    deleteCancelClicked()
  )
  $('.delete-confirm').click( () ->
    deleteComment()
  )

@submitComment = (fileId) ->
  @commentText = $('#newcomment').val()
  @fileId = fileId
  @makeNewCommentRequest()

@makeNewCommentRequest = () =>
  data = {
    comment: {
      text: @commentText,
      ycoord: @yCoord
    },
    file_id: @fileId
  }

  $.post('/api/comments', data, (response) ->
    if !response.success
      alert response.error
    else
      $('#comments-container').html( response['comments_html'] )
      hideNewCommentField()
  )

@setCommentPanelPosition = (yClick) =>
  $('#new-comment-panel').css('top', (yClick - 250 + 29) + 'px')

@showNewCommentField = () =>
  $('#note-main').addClass('new-comment-showing')
  $('#new-comment-header-container').fadeIn(200);
  $('#new-comment-container').fadeIn(200, () ->
    $('#new-comment-panel').show(200, () ->
      $('#new-comment-position-line').show(100);
    );
  );

@hideNewCommentField = () =>
  $('#new-comment-position-line').hide(100, () ->
    $('#new-comment-panel').hide(200, () ->
      $('#new-comment-header-container').fadeOut(200);
      $('#new-comment-container').fadeOut(200, () -> 
        $('#note-main').removeClass('new-comment-showing')
      )
    );
  );

@yCoordClick = (e) ->
  yCoordFromTop = e.pageY + document.getElementById('note-main').scrollTop
  @yCoord = yCoordFromTop
  @setCommentPanelPosition(yCoordFromTop)
  @showNewCommentField()

@setActive = (clickedComment) ->
  if (@activeComment)
    $(@activeComment).removeClass('active')

  if (clickedComment != @activeComment)
    @activeComment = clickedComment
    $(@activeComment).addClass('active')
  else
    @activeComment = null;

@scrollNoteToYCoord = (yCoord) =>
  $(document.getElementById('note-main')).animate({scrollTop:yCoord})


@validateUploadForm = () ->
  if ($('#notes_file').val() == '')
    $('#upload-label').addClass('error')
    return false
  if ($.trim( $('#notes_title').val() ) == '')
    $('#title-field').addClass('error')
    return false

  return true

@deleteClicked = (e) ->
  $(e.target).fadeOut(150)
  element = e.target
  while (! $(element).hasClass('comment'))
    element = $(element).parent()
  showDeleteConfirmation(element)
  return false

@showDeleteConfirmation = (element) ->
  $(element).find('.delete-confirm-panel').show(150)
  @deletingCommentElement = element

@deleteComment = () ->
  
  element = @deletingCommentElement

  id = $(element).attr('comment-id')
  
  $.ajax({
    url: '/api/comments/' + id,
    type: 'DELETE',
    error: (() ->
      alert response.error)
  })

  $(element).hide(200, () -> 
    $(element).remove()
  )

  return false  # Stop comment click action from happening

@deleteCancelClicked = () ->
  element = @deletingCommentElement
  $(element).find('.delete-confirm-panel').hide(150)
  $(element).find('.delete-button').fadeIn(150)
  return false
