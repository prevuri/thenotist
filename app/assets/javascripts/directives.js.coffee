notistApp = angular.module('notistApp', [])

# For use with progress spinners - starts a jQuery spin animation
#    set ng-spin="attr" where attr is boolean for spinning on/off
notistApp.directive('ngSpinner', () ->
  (scope, el, attr) ->
    if attr.ngSpinner is 'true'
      $(el).spin
        lines: 7,
        length: 0,
        width: 5,
        radius: 10,
        corners: 1.0,
        trail: 50,
        speed: 1.2,
        shadow: false,
        color: '#a6a6a6'
)

# For file upload forms to detect when a file has been selected
notistApp.directive('ngUpload', () ->
  (scope, el, attr) ->
    $(el).fileupload
      dataType: 'json'
      add: (e, data) =>
        scope.uploadAdd(data)
        scope.$apply()
      progress: (e, data) =>
        scope.uploadProgress(data)
        scope.$apply()
      done: (e, data) =>
        scope.uploadDone(data)
        scope.$apply()
      fail: (e, data) =>
        scope.uploadFail(data)
        scope.$apply()
)

# Make clicking an element simulate the click of another, specified by ID
notistApp.directive('ngSimulateClick', () ->
  (scope, el, attr) ->
    if attr.ngSimulateClick
      $(el).on('click', () ->
        document.getElementById(attr.ngSimulateClick).click()
        scope.$apply()
      )
)
