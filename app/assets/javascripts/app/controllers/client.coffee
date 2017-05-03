angular.module('Constructor').controller 'ClientController', class ClientController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl              = @
    @scope.users_list        = @pHelper.get('users_list')
    @scope.shared_users      = @pHelper.get('shared_users')
    @scope.shared_users_json = @pHelper.get('shared_users_json')

  shareClient: () ->
    scope = @scope
    name  = $('select option:selected').val()

    @http.post(@pHelper.get('url_find_user_by_name'), name: name)
    .success (response) ->
      scope.ctrl.addSharedUser(response.user)
    .error (response) ->
      debugger

  addSharedUser: (user) ->
    return if user == undefined
    if @scope.shared_users.find((el) -> el.id == user.id) == undefined
      @scope.shared_users.push(user)
      shared_users_json = JSON.parse(@scope.shared_users_json)
      shared_users_json.push(user.id)
      @scope.shared_users_json = JSON.stringify(shared_users_json)

  removeSharedUser: (id) ->
    user = @scope.shared_users.find((el) -> el.id == id)
    index = @scope.shared_users.indexOf(user)
    @scope.shared_users.splice(index, 1)

    shared_users_json = JSON.parse(@scope.shared_users_json)
    index = shared_users_json.indexOf(user.id)
    shared_users_json.splice(index, 1)
    @scope.shared_users_json = JSON.stringify(shared_users_json)
