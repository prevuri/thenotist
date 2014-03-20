@ActivityCtrl = ($scope, $resource, $route, $sce, $timeout, ActivityHtml) ->

  $scope.isEmpty = false

  $scope.init = () ->
    $scope.$root.title = null
    $scope.$root.section = 'home'
    success = (data) ->
      if data.html.length == 0
        $scope.isEmpty = true
      $scope.activityHtml = $sce.trustAsHtml(data.html)
      $timeout( () ->
        $scope.$root.loading = false
      , 100)
    error = (data) ->
      $scope.setAlert("Error getting activity", false)
    ActivityHtml.get(success, error)
