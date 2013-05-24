# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

  $.post('/api/comments', data, () ->
    alert('success')
  )

@setActive = (clickedComment) ->
  if (@activeComment)
    $(@activeComment).removeClass('active')

  if (clickedComment != @activeComment)
    @activeComment = clickedComment
    $(@activeComment).addClass('active')
  else
    @activeComment = null;
