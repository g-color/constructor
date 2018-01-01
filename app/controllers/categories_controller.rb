class CategoriesController < ApplicationController
  before_action :find_category, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability


  def index
    @categories = Category.all
    render layout: 'react'
  end

  def new
    @category = Category.new
    render layout: 'react'
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      log_changes(Enums::Audit::Action::CREATE)
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
    render layout: 'react'
  end

  def update
    if @category.update(category_params)
      log_changes(Enums::Audit::Action::UPDATE)
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroyed?
      flash[:alert] = 'Не может быть удалено, так как существует зависимость'
    else
      @category.destroy
      log_changes(Enums::Audit::Action::DESTROY)
    end
    redirect_to categories_path
  end

  private

  def cantbe_destroyed?
    ConstructorObject.exists?(category_id: @category.id) ||
      Product.exists?(category_id: @category.id)
  end

  def check_ability
    authorize! :manage, Category
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :product)
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'category',
      object_name: @category.name,
      object_link: @category.link,
      action:      action
    ).call
  end
end
