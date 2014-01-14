# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@MainCtrl = ($scope) ->

  $scope.keypress = () ->
    if window.event.keyCode is 27
      $scope.$parent.$broadcast('escapePressed')