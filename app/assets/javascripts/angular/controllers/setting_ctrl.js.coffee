@app.controller "SettingCtrl", ["$scope", "$timeout", "Setting", \
                ($scope, $timeout, Setting) ->

  $scope.setting = {}
  $scope.isEditing = false

  init = ->
    Setting.get(1)
    .then (res) ->
      $scope.setting = res

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.editSetting = () ->
    $scope.isEditing = true

  $scope.updateSetting = () ->
    Setting.update($scope.setting)
    .then (res) ->
      $scope.isEditing = false
    .catch (errResponse) ->
      console.log(errResponse)

  init()
]