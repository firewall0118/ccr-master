@app.factory "AgeGroup", ["Restangular", (Restangular) ->
  new class AgeGroup
    constructor: ->

    get: (id)->
      Restangular.one("age_groups", id).get()

    all: ->
      Restangular.all("age_groups").getList()

    create: (attrs) ->
      restangular = Restangular.all("age_groups")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      Restangular.one("age_groups", resource.id).patch(resource)

    delete: (resource) ->
      Restangular.one('age_groups', resource.id).remove()

]
