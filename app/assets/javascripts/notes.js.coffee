# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#note-main').click( (e) ->
    yCoordClick(e)
  )
  $('#new-comment-submit').click( () ->
    submitComment( $('#new-comment-submit').attr('file-id') )
  )
  $('.comment').click( () ->
    setActive(this);
    scrollNoteToYCoord( $(this).attr('ycoord') )
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
      hideNewCommentField()
  )

@setCommentPanelPosition = (yClick) =>
  $('#new-comment-panel').css('top', (yClick - 250 + 29) + 'px')

@showNewCommentField = () =>
  $('#new-comment-container').fadeIn(200, () ->
    $('#new-comment-panel').show(200, () ->
      $('#new-comment-position-line').show(100);
    );
  );

@hideNewCommentField = () =>
  $('#new-comment-position-line').hide(100, () ->
    $('#new-comment-panel').hide(200, () ->
      $('#new-comment-container').fadeOut(200)
    );
  );

@yCoordClick = (e) ->
  @yCoord = e.pageY + document.getElementById('note-main').scrollTop
  @setCommentPanelPosition(e.pageY)
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

