@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, ActivityHtml) ->

  $scope.init = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      alert(data) 
    ActivityHtml.get(success, error)
