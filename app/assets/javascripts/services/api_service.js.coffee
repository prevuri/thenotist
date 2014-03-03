service = angular.module("apiService", ["ngResource"])

service.factory("NotesApi", ($resource) ->
  $resource(
    "/api/notes/:id", {},
    delete: {
      method: 'DELETE'
    }
  )
).factory("FlagReportsApi", ($resource) ->
  $resource(
    "/api/flag_reports", {}
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
    "/api/activity/user/:id", {}
  )
).factory("UserApi", ($resource) ->
  $resource(
    "/api/users/:id", {}
  )
).factory("UserBuddiesApi", ($resource) ->
  $resource(
    "/api/users/:id/buddies", {}
  )
)