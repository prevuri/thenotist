@DirectToS3Ctrl = ($scope, $http) ->
  $scope.init = ->
    $("#direct-to-s3-uploader").S3Uploader()
    return false

