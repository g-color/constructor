class ProductsController < ApplicationController
  autocomplete :constructor_object, :name, :full => true

  before_action :find_product, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_ability

  def index
    @products = Product.includes(:category, :unit).all
    @products = @products.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
    @products = @products.where(category_id: params[:category])                      if params[:category].present?
  end

  def new
    @product = Product.new
    gon.push(
      product:      @product,
      compositions: [],
      templates:    [],
      sets:         [],
    )
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      if @product.custom
        @product.save_sets(JSON.parse(params[:product_sets]))
      else
        @product.save_compositions(JSON.parse(params[:product_compositions]))
      end
      log_changes(Enums::Audit::Action::CREATE)
      flash[:notice] = 'Продукт успешно сохранен'
      redirect_to edit_product_path(@product)
    else
      flash.now[:alert] = @product.errors.messages[:base].first if @product.errors.messages[:base].present?
      gon.push(
        product:      @product,
        compositions: JSON.parse(params[:product_compositions]),
        templates:    JSON.parse(params[:product_templates]),
        sets:         JSON.parse(params[:product_sets]),
      )
      render 'new'
    end
  end

  def edit
    gon.push(
      product:      @product,
      compositions: @product.get_compositions,
      templates:    @product.get_templates,
      sets:         @product.get_sets,
    )
  end

  def update
    if @product.update(product_params)
      if @product.custom
        @product.save_sets(JSON.parse(params[:product_sets]))
      else
        @product.save_compositions(JSON.parse(params[:product_compositions]))
      end
      log_changes(Enums::Audit::Action::UPDATE)
      flash[:notice] = 'Продукт успешно сохранен'
      redirect_to edit_product_path(@product)
    else
      flash.now[:alert] = @product.errors.messages[:base].first if @product.errors.messages[:base].present?
      gon.push(
        product:      @product,
        compositions: JSON.parse(params[:product_compositions]),
        templates:    JSON.parse(params[:product_templates]),
        sets:         JSON.parse(params[:product_sets]),
      )
      render 'edit'
    end
  end

  def destroy
    if StageProduct.exists?(product_id: @product.id)
      flash[:alert] = "Can't be destroyed"
    else
      @product.destroy
      log_changes(Enums::Audit::Action::DESTROY)
    end
    redirect_to products_path
  end

  def info
    product = Product.find(params[:id])
    ajax_ok(
      name: product.name,
      unit: product.unit.name
    )
  end

  private

  def check_ability
    authorize! :manage, Product
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category_id, :unit_id, :profit, :stage,
      :description, :hint, :custom, :display_components, :product_compositions, :product_templates, :product_sets)
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'product',
      object_name: @product.name,
      object_link: @product.link,
      action:      action
    ).call
  end
end
