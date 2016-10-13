@app.factory "ProviderAttendance", ["Restangular", (Restangular) ->
  new class ProviderAttendance
    constructor: ->

    get: (id)->
      Restangular.one("provider_attendances", id).get()

    all: (params) ->
      Restangular.all("provider_attendances").getList(params)

    create: (attrs) ->
      restangular = Restangular.all("provider_attendances")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("provider_attendances", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('provider_attendances', resource.id).remove()

]
