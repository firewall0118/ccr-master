@app.controller "AttendanceCtrl", ["$scope", "$window", "Provider", "ProviderAttendance", \
                ($scope, $window, Provider, ProviderAttendance) ->
  $scope.provider_id = {}
  $scope.attendances = []

  $scope.init = (provider_id)->
    $scope.provider_id = provider_id
    today = new Date()
    $scope.year = today.getFullYear()
    $scope.month = today.getMonth() + 1
    $scope.getAttendances()

  $scope.getAttendances = ->
    params =
      year: $scope.year
      month: $scope.month
      provider_id: $scope.provider_id
    ProviderAttendance.all(params)
    .then (res) ->
      $scope.attendances = res

  $scope.updateAttendance = (attendance) ->
    ProviderAttendance.update(attendance)
    .then (res) ->
      attendance.saved = true
      $timeout ->
        attendance.saved = false
      , 1000

    .catch (errResponse) ->
      alert(errResponse.data[0])

  $scope.closeMonth = ->
    if confirm("Once you close a period, the attendance count cannot be edited. Are you sure you want to close this attendance period?") == true
      params =
        month: $scope.month
        year: $scope.year
        id: $scope.provider_id
      Provider.close_month(params)
      .then (res) ->
        $scope.attendances.map((e) -> e.closed = true)
      .catch (errResponse) ->
        console.log(errResponse)

  $scope.isClosed = ->
    $scope.attendances.find((e) -> e.closed == true)?
]
