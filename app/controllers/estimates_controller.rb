class EstimatesController < ApplicationController
  before_action :find_estimate, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @estimates = Estimate.all
    @estimates = @estimates.where(client_id: params[:client_id]) if params[:client_id]
  end

  def new
    if params[:client_id].present?
      @estimate = Client.find(params[:client_id]).estimates.build
    else
      @estimate = Estimate.new
    end

    @products = Product.includes(:unit)
    products = [
      @products.where(stage: 1).map_for_estimate,
      @products.where(stage: 2).map_for_estimate,
      @products.where(stage: 3).map_for_estimate,
    ]
    gon.push(
      products: products,
      discount: {
        name: nil,
        values: @estimate.discount_by_stages
      },
      estimate: {
        area:  0,
        price: 0,
      }
    )
  end

  def create
    @estimate = Estimate.new(estimate_params.merge(price: 0))
    if params[:estimate][:discount_by_stages].present?
      params[:estimate][:discount_by_stages].each do |key, value|
        @estimate.discount_by_stages[key.to_i] = value
      end
    end

    if @estimate.save
      @estimate.calc_parameters
      redirect_to estimates_path
    else
      render 'new'
    end
  end

  def edit
    @products = Product.includes(:unit)
    products = [
      @products.where(stage: 1).map_for_estimate,
      @products.where(stage: 2).map_for_estimate,
      @products.where(stage: 3).map_for_estimate,
    ]
    gon.push(
      products: products,
      discount: {
        name: nil,
        values: @estimate.discount_by_stages
      },
      estimate: {
        area:  @estimate.area,
        price: @estimate.price,
      }
    )
  end

  def update
    byebug
    if @estimate.update(estimate_params)
      @estimate.calc_parameters
      redirect_to estimates_path
    else
      render 'edit'
    end
  end

  def destroy
    @estimate.destroy
    redirect_to estimates_path
  end

  def files
    f = AssetFile.create(data: params[:file])
    render json: {
      id: f.id,
      name: f.data_file_name,
      src: f.image? ? f.data.url : ActionController::Base.helpers.asset_url('file-icon.png')
    }
  end

  private

  def find_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(
      :name, :client_id, :area, :first_floor_height, :discount_by_stages, :json_stages,
      client_files_attributes:    [:id, :asset_file_id, :_destroy],
      technical_files_attributes: [:id, :asset_file_id, :_destroy],
    )
  end

  def map_product

  end
end
