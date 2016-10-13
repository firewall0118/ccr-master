@app.controller "AgeGroupCtrl", ["$scope", "$timeout", "AgeGroup", \
                ($scope, $timeout, AgeGroup) ->

  $scope.age_groups = []
  $scope.age_group = null
  $scope.current_index = null

  $scope.getAgeGroups = ->
    AgeGroup.all()
    .then (res) ->
      $scope.age_groups = res

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.editAgeGroup = (index) ->
    $scope.age_group = $scope.age_groups[index]
    $scope.current_index = index

  $scope.updateAgeGroup = (index) ->
    AgeGroup.update($scope.age_group)
    .then (res) ->
      $scope.age_groups[$scope.current_index] = res
      $scope.current_index = null

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.filterMonth = (months) ->
    year = parseInt(months / 12)
    month = months % 12

    result = ""
    result = "#{year} year" if year > 0
    result = "#{result}s" if year > 1
    if month > 0
      result = result + " #{month} month"
      result = "#{result}s" if month > 1
    result
]
