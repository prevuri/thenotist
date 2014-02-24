@ActivityCtrl = ($scope, $resource, $route, $sce, ActivityHtml) ->

  $scope.init = () ->
    $scope.$root.title = null
    $scope.$root.section = 'home'
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      $scope.setAlert("Error getting activity", false) 
    ActivityHtml.get(success, error)
