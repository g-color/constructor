class ClientsController < ApplicationController
  before_action :find_client, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @owned     = UserClient.owner(current_user)
    @delegated = UserClient.delegated(current_user)
    @archived  = UserClient.archived(current_user)

    if params[:name].present?
      @owned     = @owned.select     { |m| m.client.full_name.downcase.include? params[:name].downcase }
      @delegated = @delegated.select { |m| m.client.full_name.downcase.include? params[:name].downcase }
      @archived  = @archived.select  { |m| m.client.full_name.downcase.include? params[:name].downcase }
    end

    gon.push(
      owned_users:     map_to_json(@owned),
      delegated_users: map_to_json(@delegated),
      archived_users:  map_to_json(@archived),
      show_archived:   params[:archived].present?
    )
  end

  def new
    session[:return_to] ||= request.referer

    @client = Client.new
    @shared_users = []
    gon.push(
      client:            @client,
      users_list:        User.where.not(id: current_user.id),
      shared_users:      @shared_users,
      shared_users_json: @shared_users.map(&:id).to_json
    )
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      @client.assign_owner(current_user)
      @client.share(JSON.parse(params[:client_users]) << current_user.id)
      log_changes(Enums::Audit::Action::CREATE)
      redirect_to session.delete(:return_to)
    else
      gon.push(
        client:            @client,
        users_list:        User.where.not(id: current_user.id),
        shared_users:      [],
        shared_users_json: params[:client_users]
      )
      render 'new'
    end
  end

  def edit
    authorize! :view, @client
    @shared_users = UserClient.where(client: @client).where.not(user: current_user).map(&:user)
    gon.push(
      client:            @client,
      users_list:        User.where.not(id: current_user.id),
      shared_users:      @shared_users,
      shared_users_json: @shared_users.map(&:id).to_json
    )
  end

  def update
    authorize! :edit, @client
    if @client.update(client_params)
      @client.share(JSON.parse(params[:client_users]) << current_user.id)
      log_changes(Enums::Audit::Action::UPDATE)
      redirect_to clients_path
    else
      @shared_users = UserClient.where(client: @client).where.not(user: current_user).map(&:user)
      gon.push(
        client:            @client,
        users_list:        User.where.not(id: current_user.id),
        shared_users:      @shared_users,
        shared_users_json: params[:client_users]
      )
      render 'edit'
    end
  end

  def destroy
    @client.destroy
    log_changes(Enums::Audit::Action::DESTROY)
    redirect_to clients_path
  end

  protected

  def find_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :middle_name, :crm, :archived)
  end

  def map_to_json(clients)
    clients.map do |c|
      {
        id:          c.client.id,
        archived:    c.client.archived,
        full_name:   c.client.full_name,
        crm:         c.client.crm,
        estimates:   c.client.estimates.count,
        edit_link:   Rails.application.routes.url_helpers.edit_client_path(c.client),
        delete_link: Rails.application.routes.url_helpers.client_path(c.client)
      }
    end
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'client',
      object_name: @client.full_name,
      object_link: @client.link,
      action:      action
    ).call
  end
end
