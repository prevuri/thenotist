Overview = () ->
  # OVERVIEW PAGE FUNCTIONALITY
  overview_mode = false;

  $('.overview-btn').click () ->
    $('.modal-container-container').show()
    $('.modal-container').show()
    $('.full-screen-overlay').fadeIn(200)
    overview_mode = true;

    path = $(this).attr('data-path')
    $.get(path, (response) ->
      if !response.success
        alert response.error
      else
        for page in response.note.uploaded_files
          url = "/notes/" + response.note.id + "#Page-" + page.page_number
          image_container = $('.template.thumb-container').clone()
          image_container.removeClass('template')
          image = image_container.find('img')
          $(image).attr('src', page.thumb_url)
          $(image).attr('data-path',url)

          $('.modal-container').append(image_container)

        pageCount = response.note.uploaded_files.length
        thumbWidth = 240
        if pageCount < 5
          leftMargin = (documentWidth/2) - (thumbWidth/2)*pageCount
          modal_container.css("margin-left",leftMargin+"px")
    )

  @clearOverviewPage = () =>
    $('.modal-container').empty()

  $('body').keyup (e) =>
    if (e.keyCode == 27 && overview_mode) # escape
      # user has pressed space
      @clearOverviewPage()
      $('.modal-container-container').hide()
      $('.full-screen-overlay').hide()

  $('body').on "click", ".thumb-image", (e) ->
    window.location = $(this).attr("data-path")

  $('body').on "click", ".full-screen-overlay, .modal-container, .modal-container-container", (e) =>
    @clearOverviewPage()
    $('.modal-container-container').hide()
    $('.full-screen-overlay').hide()
  
  return false

$ ->
  if $('.overview-btn').length > 0
    Overview()