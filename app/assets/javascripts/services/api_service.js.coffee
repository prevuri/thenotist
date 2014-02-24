service = angular.module("apiService", ["ngResource"])

service.factory("NotesApi", ($resource) ->
  $resource(
    "/api/notes/:id", {},
    delete: {
      method: 'DELETE'
    }
  )
).factory("UploadFormHtml", ($resource) ->
  $resource(
    "/api/notes/upload_form_html", {}
  )
).factory("ActivityHtml", ($resource) ->
  $resource(
    "/api/activity", {}
  )
).factory("UserActivityHtml", ($resource) ->
  $resource(
    "/api/activity/user", {}
  )
)