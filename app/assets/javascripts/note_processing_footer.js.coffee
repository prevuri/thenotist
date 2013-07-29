NoteProcessingFooter = () ->
  timer = 0
  processing_id = 0

  @showSpinner = () =>
    $('.spinner-container').spin
      lines: 6,
      length: 0,
      width: 5,
      radius: 6,
      corners: 1.0,
      trail: 50,
      speed: 1.2,
      shadow: false,
      color: '#a6a6a6'

  @checkStatus = () ->
    $.ajax
      url: '/api/notes/',
      type: 'get',
      async: false,
      success: (response) ->
        num_processing = 0
        _.each response.notes, (n) -> 
          if !n.processed
            ++num_processing 
            processing_id = n.id
        if num_processing == 0
          clearInterval(timer)
          $('.note-status-text').text("Finished processing.")
          $('.note-status-link').show()
          $('.spinner-container').hide()
          $('.success-glyph').show()
          $('.note-status-link').attr('href', '/notes/' + processing_id)

  @initPolling = () =>
    timer = window.setInterval(@checkStatus, 5000)

  @showSpinner()
  @initPolling()

$ ->
  if $('.processing-status-container').length > 0
    NoteProcessingFooter()
