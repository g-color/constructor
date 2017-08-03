angular.module('Constructor').controller 'ClientController', class ClientController
  @$inject: ['$scope', '$http', '$filter', 'pHelper']

  constructor: (@scope, @http, @filter, @pHelper) ->
    @scope.ctrl              = @
    @scope.client            = @pHelper.get('client')
    @scope.users_list        = @pHelper.get('users_list')
    @scope.shared_users      = @pHelper.get('shared_users')
    @scope.shared_users_json = @pHelper.get('shared_users_json')

    @scope.owned_users       = @pHelper.get('owned_users')
    @scope.delegated_users   = @pHelper.get('deledated_users')
    @scope.showArchived      = @pHelper.get('show_archived')

    client     = @scope.client
    client.crm = parseInt(client.crm) if client && client.crm != null

  ownedPresent: () ->
    @scope.owned_users.length > 0

  delegatedPresent: () ->
    @scope.delegated_users.length > 0

  showClient: (client) ->
    if @scope.showArchived then true else !client.archived

  clientRowClass: (client) ->
    if client.archived then 'archived-client' else ''

  shareClient: () ->
    scope = @scope
    name  = $('select option:selected').val()

    @http.post(@pHelper.get('url_find_user_by_name'), name: name)
    .success (response) ->
      scope.ctrl.addSharedUser(response.user)
    .error (response) ->
      console.log(response)

  addSharedUser: (user) ->
    return if user == undefined
    if @scope.shared_users.find((el) -> el.id == user.id) == undefined
      @scope.shared_users.push(user)
      shared_users_json = JSON.parse(@scope.shared_users_json)
      shared_users_json.push(user.id)
      @scope.shared_users_json = JSON.stringify(shared_users_json)

  removeSharedUser: (id) ->
    user  = @scope.shared_users.find((el) -> el.id == id)
    index = @scope.shared_users.indexOf(user)
    @scope.shared_users.splice(index, 1)

    shared_users_json = JSON.parse(@scope.shared_users_json)
    index = shared_users_json.indexOf(user.id)
    shared_users_json.splice(index, 1)
    @scope.shared_users_json = JSON.stringify(shared_users_json)

  openEstimates: (id) ->
    host     = window.location.host
    protocol = window.location.protocol
    url      = protocol + "//" + host + "/estimates?client_id=" + id
    window.location.href = url

  updateCrm: ->
    client     = @scope.client
    client.crm = parseInt(client.crm.toString().substring(0, 7))
