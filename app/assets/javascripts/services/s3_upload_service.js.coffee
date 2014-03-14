module = angular.module("s3UploadService", [])

module.service("s3Upload", () ->
  this.init = ->
    $('#upload_form_tag').S3Uploader
      remove_completed_progress_bar: false
      allow_multiple_files: false
      click_submit_target: $('.direct-upload-submit')
    return null

  this.uploadComplete = (callback) ->
    $('#upload_form_tag').bind "s3_upload_complete", (e, content) ->
      s3_key_val = $('#s3_key_tag').val()
      callback(s3_key_val)
    return null

  this.uploadFailed = (callback) ->
    $('#upload_form_tag').bind "s3_upload_failed", (e, content) ->
      callback()
    return null

  return null
)
