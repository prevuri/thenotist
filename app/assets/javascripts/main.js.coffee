# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

angular.module('notistApp', []).config(['$httpProvider', ($httpProvider) ->
  # $httpProvider.interceptors.push('myHttpInterceptor');
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@MainCtrl = ($scope) ->

  $scope.keypress = () ->
    if window.event.keyCode is 27
      $scope.$parent.$broadcast('escapePressed')
