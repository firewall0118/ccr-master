@app.factory "Scale", ["Restangular", (Restangular) ->
  new class Scale
    constructor: ->

    get: (id)->
      Restangular.one("scales", id).get()

    all: ->
      Restangular.all("scales").getList()

    create: (attrs) ->
      restangular = Restangular.all("scales")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("scales", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('scales', resource.id).remove()
]
