@app.factory "Setting", ["Restangular", (Restangular) ->
  new class Setting
    constructor: ->

    get: (id) ->
      Restangular.one("settings", id).get()

    update: (resource) ->
      Restangular.one("settings", resource.id).patch(resource)
]
