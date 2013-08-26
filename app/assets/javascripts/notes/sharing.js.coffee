Sharing = () ->
  #SHARING



  

  @getAutocompleteBuddies = () =>
    $.get('/api/buddies', (response) =>
      @source = $.map(response, (value, key) =>
        {
          label: value,
          value: key,
          id: value
        })
      $(".tagsinput").tagsInput({
        autocomplete_url: '',
        autocomplete: {source:@source},
        width: '520px'
      });
    )

  @attain
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

  $('.share-note').click (e) =>
    @getAutocompleteBuddies()

  #TODO: share button click event calling share with user

  # @shareClick = (e) =>
  #   $.get('/api/buddies', (response) =>
  #     $(e.target).parents('.note-item').find('#buddies').autocomplete({
  #       source: $.map(response, (value, key) =>
  #         return {
  #           label: value,
  #           value: value,
  #           id: key
  #         }),
  #       select: (event, ui) =>
  #         if e.target.getAttribute("note_id")
  #           @shareWithUser(event, ui, $(e.target).attr("note_id"))
  #         else
  #           @shareWithUser(event, ui, $(e.target).parent().attr("note_id"))
  #     })
  #   )
  #   $(e.target).parents('.note-item').children('.tooltip').toggleClass("hidden", 1000)
    
  # return false  
$ ->
  if $('.share-note').length > 0
    Sharing()