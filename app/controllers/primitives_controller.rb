class PrimitivesController < ApplicationController
  before_action :find_primitive, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability

  def index
    @primitives = Primitive.includes(:category, :unit).all
    @primitives = @primitives.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
    @primitives = @primitives.where(category_id: params[:category])                      if params[:category].present?
  end

  def new
    @primitive = Primitive.new
  end

  def create
    @primitive = Primitive.new(primitive_params.merge(date: Time.now))
    if @primitive.save
      PriceUpdateJob.perform_later(@primitive)
      redirect_to primitives_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    params = primitive_params
    params.merge!(date: Time.now) unless price_equal?
    if @primitive.update(params)
      PriceUpdateJob.perform_later(@primitive)
      redirect_to primitives_path
    else
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroy?
      flash[:alert] = "Can't be destroyed"
    else
      @primitive.destroy
    end
    redirect_to primitives_path
  end

  def update_price
    primitive = Primitive.find(params[:primitive_id])
    primitive.update(price: params[:price], date: Date.today)
  end

  private

  def check_ability
    authorize! :manage, Primitive
  end

  def cantbe_destroy?
    Composition.exists?(children_id: @primitive.id) || ProductComposition.exists?(constructor_object_id: @primitive.id) || StageProductSetValue.exists?(constructor_object_id: @primitive.id)
  end

  def price_equal?
    primitive_params[:price] == @primitive.price
  end

  def find_primitive
    @primitive = Primitive.find(params[:id])
  end

  def primitive_params
    params.require(:primitive).permit(:name, :category_id, :unit_id, :price)
  end
end
