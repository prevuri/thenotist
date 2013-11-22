Sharing = () ->
  #SHARING

  $('.share-note').click (e) =>
    @initializeShareModal(e)

  $('.share-button').click (e) =>
    @shareWithUser(e)

  @initializeShareModal = (e) =>
    @sharedItem = $(e.target).parents('.note-item')
    @shareForm = @sharedItem.find('.form')
    $.get('/api/buddies', (response) =>
      $(@shareForm).magicSuggest({
        width: 530,
        height: 100,
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
    shareIds = $(event.target).parents('.share-note-container').find('#ms-sel-ctn-0 input[type=hidden]').val()
    note_id = $(event.target).parents('.notes-list-item').attr('data-id')
    data = {
      id: note_id,
      userids: shareIds
    }
    $.post('/api/notes/share', data, (response) =>
      if !response.success
        alert response.error
    )
  # @getAutocompleteBuddies = () =>
  #   $.get('/api/buddies', (response) =>
  #     @source = $.map(response, (value, key) =>
  #       {
  #         label: value, 
  #         value: key,
  #         id: value
  #       })
  #     $(".tagsinput").tagsInput({
  #       autocomplete_url: '',
  #       autocomplete: {source:@source},
  #       width: '520px'
  #     });
  #   )
  

  # $('.form-container').find('.ms-sel-ctn :hidden')

  
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