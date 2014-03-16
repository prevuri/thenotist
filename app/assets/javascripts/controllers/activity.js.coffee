@ActivityCtrl = ($scope, $resource, $route, $sce, $timeout, ActivityHtml) ->

  $scope.init = () ->
    $scope.$root.title = null
    $scope.$root.section = 'home'
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
      $timeout( () ->
        $scope.$root.loading = false
      , 100)
    error = (data) ->
      $scope.setAlert("Error getting activity", false) 
    ActivityHtml.get(success, error)
