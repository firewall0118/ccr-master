@app.controller "ContractCtrl", ["$scope", "$window", "$filter", "Contract", ($scope, $window, $filter, Contract) ->

  $scope.contracts = []
  $scope.contract = {}
  $scope.child_id = null
  $scope.funder_id = null
  $scope.provider_id = null

  $scope.getContracts = (active=false)->
    params =
      provider_id: $scope.provider_id
      child_id: $scope.child_id
      funder_id: $scope.funder_id
      active: active
    Contract.all(params)
    .then (res) ->
      $scope.contracts = res

    .catch (errResponse) ->
      console.log(errResponse)

  $scope.addContract = ->
    $scope.contract = {}
    $scope.alerts = []
    $scope.submitted = false
    $("#contract-modal").modal('show')
    return

  $scope.editContract = (contract) ->
    $scope.contract = angular.copy contract
    $scope.child_id = contract.child.id
    $scope.contract.hasDiscount = if $scope.contract.discount? then "true" else "false"
    $scope.alerts = []
    $scope.submitted = true
    $("#contract-modal").modal('show')
    return

  $scope.createContract = ->
    if $scope.contractForm.$invalid
      $scope.submitted = true
      return

    $scope.contract.child_id = $scope.child_id
    Contract.create($scope.contract)
    .then (res) ->
      $scope.contracts.push res
      $("#contract-modal").modal('hide')
    .catch (errResponse) ->
      $scope.alerts = []
      errResponse.data.each (error) ->
        $scope.alerts.push({type: 'danger', msg: error})


  $scope.updateContract = ->
    if $scope.contractForm.$invalid
      $scope.submitted = true
      return

    params = $scope.contract
    params["child_id"] = $scope.contract.child.id

    Contract.update(params)
    .then (res) ->
      $scope.contracts = res

      $("#contract-modal").modal('hide')

    .catch (errResponse) ->
      $scope.alerts = []
      errResponse.data.each (error) ->
        $scope.alerts.push({type: 'danger', msg: error})

  $scope.transferContract = (contract) ->
    $scope.contract = angular.copy contract
    $scope.child_id = contract.child.id
    $scope.contract.hasDiscount = if $scope.contract.discount? then "true" else "false"
    $scope.alerts = []
    $scope.submitted = true
    start_date = new Date()
    start_date.setDate(start_date.getDate() + 1)

    $scope.contract.start_date = $filter('date')(start_date, 'MM/dd/y')
    $scope.contract.is_transfer = true
    $("#contract-modal").modal('show')
    return

  $scope.deleteContract = (contract) ->
    bConfirm = $window.confirm('Are you absolutely sure you want to delete?');
    if bConfirm
      Contract.delete(contract)
      .then (res) ->
        index = $scope.contracts.findIndex((e)-> e.id == contract.id)
        $scope.contracts.splice index, 1
]
