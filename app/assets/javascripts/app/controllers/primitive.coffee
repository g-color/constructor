angular.module('Constructor').controller 'PrimitiveController', class PrimitiveController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl              = @
    @scope.users_list        = @pHelper.get('users_list')
    @scope.shared_users      = @pHelper.get('shared_users')
    @scope.shared_users_json = @pHelper.get('shared_users_json')

  dateClass: (date) ->
    today = new Date()
    date  = new Date(date)

    months = (today.getFullYear() - date.getFullYear()) * 12
    months -= date.getMonth() + 1
    months += today.getMonth()

    if months >= 1
      return 'btn dropdown-toggle btn-danger'
    else
      return 'btn dropdown-toggle btn-default'
