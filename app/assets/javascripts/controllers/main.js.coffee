# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@MainCtrl = ($scope) ->

  $scope.alert = {}

  $scope.$on('$routeChangeStart', () ->
    $scope.$root.loading = true
  )

  $scope.keypress = () ->
    if window.event.keyCode is 27
      $scope.$parent.$broadcast('escapePressed')

  $scope.setAlert = (text, isSuccess) ->
    $scope.alert.success = isSuccess
    $scope.alert.text = text
    $scope.alert.show = true
