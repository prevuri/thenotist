@ProfileCtrl = ($scope, $resource, $route, $routeParams, $sce, UserActivityHtml) ->

  $scope.init = () ->
    success = (data) ->
      $scope.activityHtml = $sce.trustAsHtml(data.html)
    error = (data) ->
      alert(data) 
    UserActivityHtml.get(success, error)
