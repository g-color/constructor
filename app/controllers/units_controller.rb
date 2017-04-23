class UnitsController < ApplicationController
  before_action :find_unit, only: [:edit, :update, :destroy]
  before_action :check_ability

  def index
    @units = Unit.all
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to units_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @unit.update(unit_params)
      redirect_to units_path
    else
      render 'edit'
    end
  end

  def destroy
    @unit.destroy
    redirect_to units_path
  end

  private

  def check_ability
    authorize! :manage, Unit
  end

  def find_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:name, :product)
  end
end
