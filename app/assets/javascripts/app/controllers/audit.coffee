angular.module('Constructor').controller 'AuditController', class AuditController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl              = @
    @scope.users_list        = @pHelper.get('users_list')
    @scope.shared_users      = @pHelper.get('shared_users')
    @scope.shared_users_json = @pHelper.get('shared_users_json')

  exportCsv: () ->
    window.location.pathname = '/audits.csv'
