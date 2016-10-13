@app = angular.module("ccrApp", [
    "ngRoute"
  "ngResource"
  "restangular"
  "angular-loading-bar"
])

@app.config ["$httpProvider", "$routeProvider", ($httpProvider, $routeProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
]

@app.config ["RestangularProvider", (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")
  RestangularProvider.setRequestInterceptor( (elem, operation, what) ->
    if (operation == 'post' || operation == 'put' || operation == 'patch')
      wrapper = {}
      console.log "-- what = " + what
      wrapper[what[0..(what.length-2)]] = elem
      delete elem.createdAt;
      return wrapper
    # taken from: http://stackoverflow.com/questions/18123962/how-to-put-only-some-fields-with-restangular/18168610#18168610
  )
]
