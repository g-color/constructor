class CompositesController < ApplicationController
  before_action :find_composite, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability

  def index
    @composites = Composite.includes(:category, :unit).all
    @composites.where!('lower(name) like ?', "%#{params[:name].downcase}%") if params[:name].present?
    @composites.where!(category_id: params[:category])                      if params[:category].present?
    @composites.order!(:name)
  end

  def new
    @composite = Composite.new
  end

  def create
    @composite = Composite.new(composite_params.merge(date: Time.now))
    if @composite.save
      PriceUpdateJob.perform_later(@composite)
      log_changes(Enums::Audit::Action::CREATE)
      flash[:notice] = 'Объект успешно сохранен'
      redirect_to edit_composite_path(@composite)
    else
      flash.now[:alert] = @composite.errors.messages[:base].first if @composite.errors.messages[:base].present?
      render 'new'
    end
  end

  def edit; end

  def update
    if at_least_one_composition? && @composite.update(composite_params)
      PriceUpdateJob.perform_later(@composite)
      log_changes(Enums::Audit::Action::UPDATE)
      flash[:notice] = 'Объект успешно сохранен'
      redirect_to edit_composite_path(@composite)
    else
      flash.now[:alert] = @composite.errors.messages[:base].first if @composite.errors.messages[:base].present?
      render 'edit'
    end
  end

  def destroy
    if cantbe_destroy?
      flash[:alert] = 'Не может быть удалено, так как существует зависимость'
    else
      @composite.destroy
      log_changes(Enums::Audit::Action::DESTROY)
    end
    redirect_to composites_path
  end

  private

  def at_least_one_composition?
    exists = false
    params[:composite][:compositions_attributes].each do |key, composition|
      exists = composition["_destroy"] == "false"
      break if exists
    end

    @composite.errors.add(:base, "Должно быть не менее одного примитива или объекта") unless exists
    exists
  end

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

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'composite',
      object_name: @composite.name,
      object_link: @composite.link,
      action:      action
    ).call
  end
end
