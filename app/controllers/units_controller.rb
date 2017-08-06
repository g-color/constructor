class UnitsController < ApplicationController
  before_action :find_unit, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
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
      log_changes(Enums::Audit::Action::CREATE)
      redirect_to units_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @unit.update(unit_params)
      log_changes(Enums::Audit::Action::UPDATE)
      redirect_to units_path
    else
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroyed?
      flash[:alert] = "Не может быть удалено, так как существует зависимость"
    else
      @unit.destroy
      log_changes(Enums::Audit::Action::DESTROY)
    end
    redirect_to units_path
  end

  private

  def cantbe_destroyed?
    ConstructorObject.exists?(unit_id: @unit.id) || Product.exists?(unit_id: @unit.id)
  end

  def check_ability
    authorize! :manage, Unit
  end

  def find_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:name, :product)
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'unit',
      object_name: @unit.name,
      object_link: @unit.name,
      action:      action
    ).call
  end
end
