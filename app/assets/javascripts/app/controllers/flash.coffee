angular.module('Constructor').controller 'FlashController', class FlashController
  @$inject: ['$attrs', '$scope', '$http', '$filter', 'toaster', 'pHelper']

  constructor: (@attrs, @scope, @http, @filter, @toaster, @pHelper) ->
    @scope.ctrl   = @
    @scope.alert  = { type: 'error', body: @attrs.alert,  showCloseButton: true, timeout: 1500 }
    @scope.notice = { type: 'info',  body: @attrs.notice, showCloseButton: true, timeout: 1500 }

    this.notify()

  notify: () ->
    toaster = @toaster
    messages = [@scope.alert, @scope.notice]
    angular.forEach(messages, (i,k) -> toaster.pop(i) if i.body != undefined )
