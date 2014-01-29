$ ->
  $("#flag_report_btn").click ->
    @note_id = $("#flag_report_btn").attr('note_id')
    data = {'note_id' : @note_id}
    $.post('/api/flag_reports', data, (response) =>
      if !response.success
        alert response.error
      else
        console.log("Flag Report has been sent")
    )