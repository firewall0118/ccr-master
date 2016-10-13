@app.factory "Child", ["Restangular", (Restangular) ->
  new class Child
    constructor: ->

    get: (id)->
      Restangular.one("children", id).get()

    all: (params) ->
      Restangular.all("children").getList(params)

    create: (attrs) ->
      restangular = Restangular.all("children")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("children", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('children', resource.id).remove()
]
