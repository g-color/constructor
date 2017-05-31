angular.module 'Constructor', ['toaster', 'ngResource', 'ngAnimate']

$(document).on 'turbolinks:load', ->
  angular.bootstrap document.body, ['Constructor']
