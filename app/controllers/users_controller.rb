class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability, except: [:show, :find_by_name]

  def find_by_name
    user = nil
    if params[:name]
      name = params[:name].split
      user = User.find_by(last_name: name[0], first_name: name[1])
    end
    if params[:id]
      user = User.find(params[:id])
    end
    ajax_ok(user: user) if user
  end

  def index
    @users = User.order(:last_name, :first_name).all
    if params[:name].present?
      @users = @users.select do |m|
        m.full_name.downcase.include? params[:name].downcase
      end
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_changes(Enums::Audit::Action::CREATE)
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    update_params = user_params
    update_params = user_params.except(:password, :password_confirmation) unless user_params[:password].present?
    if @user.update(update_params)
      log_changes(Enums::Audit::Action::UPDATE)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.update(email: "#{@user.email}_#{Time.now.to_i}")
    @user.destroy
    log_changes(Enums::Audit::Action::DESTROY)
    redirect_to users_path
  end

  private

  def check_ability
    redirect_to root_path unless can? :manage, User
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :first_name, :last_name, :phone, :crm, :role)
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'user',
      object_name: @user.full_name,
      object_link: @user.link,
      action:      action
    ).call
  end
end
