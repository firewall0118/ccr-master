@app.controller "ScaleCtrl", ["$scope", "$timeout", "Scale", \
                ($scope, $timeout, Scale) ->

  $scope.scales = []
  $scope.scale = null
  $scope.current_index = null

  $scope.getScales = ->
    Scale.all()
    .then (res) ->
      $scope.scales = res

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.editScale = (index) ->
    $scope.scale = $scope.scales[index]
    $scope.current_index = index

  $scope.updateScale = (index) ->
    Scale.update($scope.scale)
    .then (res) ->
      $scope.scales[$scope.current_index] = res
      $scope.current_index = null

    .catch (errResponse) ->
      console.log(errResponse)

]
