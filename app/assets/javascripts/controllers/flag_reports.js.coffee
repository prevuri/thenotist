@FlagReportCtrl = ($scope, $http, FlagReportsApi) ->
  $scope.files = []

  $scope.init = () ->
    success = (data) ->
      $scope.flagReports = data.flag_reports
      $scope.unresolvedflagreports = data.unresolvedflagreports
      $scope.ufcount = data.unresolvedflagreports.count
      $scope.resolvedflagreports = data.resolvedflagreports
      $scope.rfcount = data.resolvedflagreports.count
    error = (data) ->
      $scope.setAlert("Error loading flag reports", false)
    FlagReportsApi.get(success, error)

  $scope.updateReport = (reportId) ->
    data = {'report_id': reportId}
    $http({method: 'PUT', url: '/api/flag_reports/' + reportId, params: data}).
      success( (data, status, headers, config) ->
        console.log("Flag Report has been updated")
      ).error( (data, status, headers, config) ->
        alert data        
      )
    location.reload()

  