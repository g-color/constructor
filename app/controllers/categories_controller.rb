class CategoriesController < ApplicationController
  before_action :find_category, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability


  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroyed?
      flash[:alert] = "Не может быть удалено, так как существует зависимость"
    else
      @category.destroy
    end
    redirect_to categories_path
  end

  private

  def cantbe_destroyed?
    ConstructorObject.exists?(category_id: @category.id) || Product.exists?(category_id: @category.id)
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
end
