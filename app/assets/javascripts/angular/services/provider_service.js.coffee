@app.factory "Provider", ["Restangular", (Restangular) ->
  new class Provider
    constructor: ->

    get: (id)->
      Restangular.one("providers", id).get()

    all: (params) ->
      Restangular.all("providers").getList(params)

    create: (attrs) ->
      restangular = Restangular.all("providers")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("providers", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('providers', resource.id).remove()

    close_month: (params) ->
      Restangular.one('providers', params.id).customPOST({}, 'close_month', params)

]
