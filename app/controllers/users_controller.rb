class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :destroy]
  before_action :check_ability

  def find_by_name
    name = params[:name].split
    user = User.find_by(last_name: name[0], first_name: name[1])
    ajax_ok(user: user) if user
  end

  def index
    @users = User.all
    if params[:name].present?
      @users = @users.select do |m|
        m.full_name.downcase.include? params[:name].downcase
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
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
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def check_ability
    authorize! :manage, User
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :first_name, :last_name, :phone, :crm, :role)
  end
end
