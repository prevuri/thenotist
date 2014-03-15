service = angular.module("apiService", ["ngResource"])

service.factory("NotesApi", ($resource) ->
  $resource(
    "/api/notes/:id", {},
    delete: {
      method: 'DELETE'
    },
    update: {
      method: 'PUT'
    }
  )
).factory("NotesUserApi", ($resource) ->
  $resource(
    "/api/usernotes/:id", {},
  )
).factory("NotesShareApi", ($resource) ->
    $resource(
      "/api/notes/share", {},
      share: {
        method: 'POST'
      }
    )
).factory("NotesUnshareApi", ($resource) ->
    $resource(
      "/api/notes/unshare", {},
      remove: {
        method: 'POST'
      }
    )
).factory("NotesUnsubscribeApi", ($resource) ->
    $resource(
      "/api/notes/unsubscribe/:id", {},
      remove: {
        method: 'GET'
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
    "/api/activity/user/:id", {}
  )
).factory("UserApi", ($resource) ->
  $resource(
    "/api/users/:id", {}
  )
).factory("UserFriendsApi", ($resource) ->
  $resource(
    "/api/users/:id/friends", {}
  )
)
