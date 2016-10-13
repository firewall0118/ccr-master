@app.controller "ChildrenCtrl", ["$scope", "$timeout", "$window", "Child", \
                ($scope, $timeout, $window, Child) ->

  $scope.children = []
  $scope.child = null
  $scope.family_id = null
  $scope.submitted = false

  $scope.getChildren = (family_id) ->
    $scope.family_id = family_id
    params =
      family_id: $scope.family_id

    Child.all(params)
    .then (res) ->
      $scope.children = res

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.addChild = ->
    $scope.child = {}
    $scope.alerts = []
    $scope.submitted = false
    $("#child-modal").modal('show')
    return

  $scope.editChild = (child) ->
    $scope.child = angular.copy child
    $scope.alerts = []
    $scope.submitted = true
    $("#child-modal").modal('show')
    return

  $scope.createChild = ($event, close=true) ->
    $event.preventDefault() if $event
    if $scope.childForm.$invalid
      $scope.submitted = true
      return

    $scope.alerts = []
    $scope.child["family_id"] = $scope.family_id
    Child.create($scope.child)
    .then (res) ->
      $scope.children.push res

      $scope.child = {}
      if close
        $("#child-modal").modal('hide')
      $scope.alerts.push({type: 'success', msg: "Child is created successfully"})

    .catch (errResponse) ->
      errResponse.data.each (error) ->
        $scope.alerts.push({type: 'danger', msg: error})


  $scope.updateChild = ($event) ->
    $event.preventDefault() if $event
    $scope.alerts = []

    Child.update($scope.child)
    .then (res) ->
      index = $scope.children.findIndex((e)-> e.id == $scope.child.id)
      $scope.children[index] = res

      $("#child-modal").modal('hide')

    .catch (errResponse) ->
      errResponse.data.each (error) ->
        $scope.alerts.push({type: 'danger', msg: error})

  $scope.deleteChild = (child) ->
    bConfirm = $window.confirm('Are you absolutely sure you want to delete?');
    if bConfirm
      Child.delete(child)
      .then (res) ->
        index = $scope.children.findIndex((e)-> e.id == child.id)
        $scope.children.splice index, 1
]
