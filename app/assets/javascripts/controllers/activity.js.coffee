@ActivityCtrl = ($scope, $resource, $route, $sce, ActivityHtml) ->

  $scope.init = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      $scope.setAlert(data, false) 
    ActivityHtml.get(success, error)
