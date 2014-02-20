service = angular.module("apiService", ["ngResource"])

service.factory("NotesApi", ($resource) ->
  $resource(
    "/api/notes/:id", {},
    delete: {
      method: 'DELETE'
    }
  )
)