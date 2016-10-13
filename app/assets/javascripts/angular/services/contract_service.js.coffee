@app.factory "Contract", ["Restangular", (Restangular) ->
  new class Contract
    constructor: ->

    get: (id)->
      Restangular.one("contracts", id).get()

    all: (params) ->
      Restangular.all("contracts").getList(params)

    create: (attrs) ->
      restangular = Restangular.all("contracts")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("contracts", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('contracts', resource.id).remove()

]
