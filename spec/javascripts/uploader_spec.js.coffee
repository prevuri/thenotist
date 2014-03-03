describe "UploadCtrl", ->

  beforeEach ->
    @scope = {}
    @controller = new UploadCtrl(@scope)
    # $http = $injector.get('$http')
    # $httpBackend.when('GET','/posts.json').respond($fixture)

  it 'hides upload and process information initially', ->
    # controller(UploadCtrl, {$scope: $scope})
    expect(@scope.uploadShowing).toBeFalsy()