Sharing = () ->
  #SHARING



  @hideShareModal = () ->
    $('.share-note-form-container').modal('hide')

  @showErrorCode = (response) ->
    $('.error-label').html(response.error)
    $('.error-label').show()

  @updateNote = (note_id) =>
    data = {
      id: note_id
    }
    notediv = $('div[data-id='+note_id+']')
    notedivInfo = notediv.find('.info')
    $.get('/api/notes/'+note_id, (response) =>
      if response.success
        if(response.contributor_length > 1)
          notedivInfo.html("Shared with " + response.first_contributor + " and " + response.contributor_length-1 + " others")
        else if(response.contributor_length == 1)
          notedivInfo.html("Shared with " + response.first_contributor)
          
        notediv.attr("data-footer-expanded", parseInt(notediv.attr("data-footer-expanded"))+ notedivInfo.height()+15)
    )


  @initializeShareModal = (e) =>
    @sharedItem = $(e.target).parents('.note-item')
    @shareForm = @sharedItem.find('.form')
    $.get('/api/buddies', (response) =>
      $(@shareForm).magicSuggest({
        width: 530,
        height: 100,
        toggleOnClick: true,
        emptyText: 'Search for friends or groups to share note with!'
        data: $.map(response, (value, key) =>
          return {
            id: key,
            name: value.name,
            image: value.image
          }),
        renderer: (v) =>
          return '<div>' +
            '<div style="float:left;"><img class="profile-image circular" style="width:50px;height:50px"src="' + v.image + '"/></div>' +
            '<div style="padding-left: 85px;">' +
                '<div style="padding-top: 20px;font-style:bold;font-size:120%;color:#333">' + v.name + '</div>' +
                '</div>' +
            '</div><div style="clear:both;"></div>';
        })
      )

  @shareWithUser = (event) =>
    shareIds = $(event.target).parents('.share-note-form-container').find('#ms-sel-ctn-0 input[type=hidden]').val()
    note_id = $(event.target).parents('.notes-list-item').attr('data-id')
    data = {
      id: note_id,
      userids: shareIds
    }
    $.post('/api/notes/share', data, (response) =>
      if !response.success
        @showErrorCode(response)
      else
        @hideShareModal()
        @updateNote(note_id)
    )

  $('.share-note').click (e) =>
    @initializeShareModal(e)

  $('.share-button').click (e) =>
    @shareWithUser(e)

  
  # @attain
  # @shareWithUser = (event, ui, note_id) =>
  #   $('.tooltip').addClass("hidden", 1000)
  #   data = {
  #     id: note_id,
  #     userid: ui.item.id
  #   }
  #   $.post('/api/notes/share', data, (response) =>
  #     if !response.success
  #       alert response.error
  #   )

  # $('.share-note').click (e) =>
  #   @getAutocompleteBuddies()

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