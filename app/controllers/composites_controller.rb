class CompositesController < ApplicationController
  before_action :find_composite, only: [:edit, :update, :destroy]
  before_action :check_ability

  def index
    @composites = Composite.includes(:category, :unit).all
    @composites = @composites.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
    @composites = @composites.where(category_id: params[:category])                      if params[:category].present?
  end

  def new
    @composite = Composite.new
  end

  def create
    @composite = Composite.new(composite_params.merge(date: Time.now))
    if @composite.save
      PriceUpdateJob.perform_later(@composite)
      redirect_to composites_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @composite.update(composite_params)
      PriceUpdateJob.perform_later(@composite)
      redirect_to composites_path
    else
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroy?
      flash[:alert] = "Can't be destroyed"
    else
      @composite.destroy
    end
    redirect_to composites_path
  end

  private

  def check_ability
    authorize! :manage, Composite
  end

  def cantbe_destroy?
    Composition.exists?(children_id: @composite.id) || ProductComposition.exists?(constructor_object_id: @composite.id) || StageProductSetValue.exists?(constructor_object_id: @composite.id)
  end

  def find_composite
    @composite = Composite.find(params[:id])
  end

  def composite_params
    params.require(:composite).permit(:name, :category_id, :unit_id, :price, :divisibility,
      compositions_attributes: [ :id, :children_id, :value, :_destroy ])
  end
end
