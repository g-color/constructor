angular.module 'Constructor', ['ngResource']

$(document).on 'turbolinks:load', ->
  angular.bootstrap document.body, ['Constructor']
