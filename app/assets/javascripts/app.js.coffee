notistApp = angular.module('notistApp', [
  'ngRoute',
  'ngAnimate',
  'apiService',
  's3UploadService',
  'infinite-scroll',
  'angulartics',
  'angulartics.google.analytics'
  ])

notistApp.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]).config(['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode(true);
]).config(['$routeProvider', ($routeProvider) ->
    $routeProvider.
      when('/admin', {
        templateUrl: '/client_views/admin.html',
        controller: 'AdminCtrl'
      }).
      when('/flag_reports', {
        templateUrl: '/client_views/flag_reports.html',
        controller: 'FlagReportCtrl'
      }).
      when('/notes', {
        templateUrl: '/client_views/notes.html',
        controller: 'NotesCtrl'
      }).
      when('/notes/:noteId', {
        templateUrl: '/client_views/note.html',
        controller: 'NoteCtrl'
      }).
      when('/profile', {
        templateUrl: '/client_views/profile.html',
        controller: 'ProfileCtrl'
      }).
      when('/profile/:profileId', {
        templateUrl: '/client_views/profile.html',
        controller: 'ProfileCtrl'
      }).
      when('/', {
        templateUrl: '/client_views/index.html',
        controller: 'ActivityCtrl',
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
