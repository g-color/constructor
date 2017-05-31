angular.module 'Constructor', ['toaster', 'ngResource', 'ngAnimate']

$(document).on 'ready', ->
  angular.bootstrap document.body, ['Constructor']
