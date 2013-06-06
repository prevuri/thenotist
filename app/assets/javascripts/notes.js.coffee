# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@submitComment = (fileId) =>
  @commentText = $('#newcomment').val()
  @fileId = fileId
  @setYCoordModeOn()

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
      alert "Success!"
  )

@setYCoordModeOn = () =>
  @yCoordModeOn = true

@yCoordClick = (e) ->
  if (@yCoordModeOn)
    @yCoord = e.pageY + document.getElementById('note-main').scrollTop
    @yCoordModeOn = false
    @makeNewCommentRequest()

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

