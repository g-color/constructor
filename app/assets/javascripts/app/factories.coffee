angular.module('Constructor').factory 'pHelper', ->
  get: (name) ->
    gon[name]
