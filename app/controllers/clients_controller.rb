class ClientsController < ApplicationController
  before_action :find_client, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @user_clients = UserClient.joins(:client)

    unless params[:archived].present?
      @user_clients = @user_clients.where(clients: {archived: false})
    end

    @owned     = @user_clients.owner(current_user).includes(client: [:estimates])
    @delegated = @user_clients.delegated(current_user).includes(client: [:estimates])

    if params[:name].present?
      @owned = @owned.select { |m| m.client.full_name.downcase.include? params[:name].downcase }
      @delegated = @delegated.select { |m| m.client.full_name.downcase.include? params[:name].downcase }
    end
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
      @client.share(params[:client_users])
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
    redirect_to clients_path
  end

  protected

  def find_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :middle_name, :crm, :archived)
  end
end
