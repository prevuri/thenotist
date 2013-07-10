Sharing = () ->
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
      $(e.target).parents('.note-item').find('#buddies').autocomplete({
        source: $.map(response, (value, key) =>
          return {
            label: value,
            value: value,
            id: key
          }),
        select: (event, ui) =>
          if e.target.getAttribute("note_id")
            @shareWithUser(event, ui, $(e.target).attr("note_id"))
          else
            @shareWithUser(event, ui, $(e.target).parent().attr("note_id"))
      })
    )
    $(e.target).parents('.note-item').children('.tooltip').toggleClass("hidden", 1000)
    
  return false  
$ ->
  if $('.share-note').length > 0
    Sharing()