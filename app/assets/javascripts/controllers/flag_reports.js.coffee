@FlagReportCtrl = ($scope, $http) ->
  $scope.files = []

  $scope.updateReport = (reportId) ->
    data = {'report_id': reportId}
    $http({method: 'PUT', url: '/api/flag_reports/' + reportId, params: data}).
      success( (data, status, headers, config) ->
        console.log("Flag Report has been updated")
      ).error( (data, status, headers, config) ->
        alert data        
      )
    location.reload()

  