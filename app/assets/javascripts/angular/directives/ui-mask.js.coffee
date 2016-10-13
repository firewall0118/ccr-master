# <input ui-mask="<pattern>">
@app.directive "uiMask", ->
  require: "ngModel"
  link: (scope, elem, attr, ctrl) ->
    elem.mask attr.uiMask
    elem.on "keyup", ->
      scope.$apply ->
        ctrl.$setViewValue elem.val()
        return
