notistApp = angular.module('notistApp', [
  'ngRoute',
  'ngAnimate',
  'apiService'
  ])

notistApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]).config(['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode(true);
]).config(['$routeProvider', ($routeProvider) ->
    $routeProvider.
      when('/notes', {
        templateUrl: '/assets/notes.html',
        controller: 'NotesCtrl'
      }).
      when('/notes/:noteId', {
        templateUrl: '/assets/note.html',
        controller: 'NoteCtrl'
      }).
      when('/', {
        templateUrl: '/assets/index.html',
        controller: 'ActivityController',
        redirectTo: (current, path, search) ->
          if (search.goto)
            '/' + search.goto
          else
            '/'
      }).
      otherwise({
        redirectTo: '/'
      })
  ])