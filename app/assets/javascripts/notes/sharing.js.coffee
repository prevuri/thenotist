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

    notediv = $('div[data-id='+note_id+'].note-item')
    shareDiv = notediv.find('.contributor-list')
    notedivInfo = notediv.find('.info')
    $.get('/api/notes/contribs/'+note_id, (response) =>
      if response.success
        if(response.contributors.length > 1)
          notedivInfo.html("Shared with " + response.contributors[0].name + " and " + response.contributors.length + " others")
          notediv.attr("data-footer-expanded", parseInt(notediv.attr("data-footer-expanded"))+ notedivInfo.height()+15)
        else if(response.contributors.length == 1)
          notedivInfo.html("Shared with " + response.contributors[0].name)
          notediv.attr("data-footer-expanded", parseInt(notediv.attr("data-footer-expanded"))+ notedivInfo.height()+15)
        else if(response.contributors.length == 0)
          notedivInfo.html("")
          notediv.attr("data-footer-expanded", parseInt(notedivInfo.attr('data-footer')))


        shareDiv.empty()

        for contrib in response.contributors
          shareDiv.prepend("<div class='contrib-list-item' data-id='"+contrib.id+"'>
                              <div class='contrib-info'>
                                <div class='profile-container circular'>
                                  <img class='profile-image circular hoverZoomLink' src='"+contrib.image+"'>
                                </div>
                                <div class='profile-link-container'><a href='/profile/"+contrib.id+"'>"+contrib.name+"</a></div>
                                <div class='delete-contrib'>
                                  <i class='icon-remove btn'></i>
                                </div>
                              </div>
                            </div>")

    )


  @initializeShareModal = (e) =>
    @sharedItem = $(e.target).parents('.note-item')
    @shareForm = @sharedItem.find('.form')
    $.get('/api/buddies', (response) =>
      @msForm = $(@shareForm).magicSuggest({
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
      # $('#ms-input-0').addClass('form-control')
      )

  @shareWithUser = (event) =>
    shareIds = $(event.target).parents
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
        @msForm.clear()
        @updateNote(note_id)
    )



  @removeSharedUser = (e) =>

    shared_user_item = $(e.target).parents('.contrib-list-item')
    shared_user = $(shared_user_item).attr('data-id')
    note_id = $(e.target).parents('.notes-list-item').attr('data-id')

    data = {
      id: note_id,
      userid: shared_user
    }

    $.post('/api/notes/unshare', data, (response) =>
      if !response.success
        @showErrorCode(response)
      else
        $(shared_user_item).remove()
        @updateNote(note_id)
    )



  $(document).on 'click', '.delete-contrib', (e) =>
    @removeSharedUser(e)

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
