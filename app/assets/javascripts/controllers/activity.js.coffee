@ActivityCtrl = ($scope, $resource, $route, ActivityApi) ->

  $scope.activityTypeString = ->
    if this.activity.trackable_type == "Relationship"
      "USER"
    else if activity.trackable_type == "Contributor"
      "NOTE"
    else
      this.activity.trackable.class.name.upcase