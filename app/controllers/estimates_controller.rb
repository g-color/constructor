class EstimatesController < ApplicationController
  before_action :find_estimate, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @estimates = Estimate.all
  end

  def new
    @estimate = Estimate.new
    products = [
      Product.includes(:unit).where(stage: 1).map do |x|
        {
          id:     x.id,
          name:   x.name,
          unit:   x.unit.name,
          custom: x.custom,
          sets:   x.get_sets,
        }
      end,
      Product.includes(:unit).where(stage: 2).map do |x|
        {
          id:     x.id,
          name:   x.name,
          unit:   x.unit.name,
          custom: x.custom,
          sets:   x.get_sets,
        }
      end,
      Product.includes(:unit).where(stage: 3).map do |x|
        {
          id:     x.id,
          name:   x.name,
          unit:   x.unit.name,
          custom: x.custom,
          sets:   x.get_sets,
        }
      end,
    ]
    gon.push(products: products)
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
  end

  def update
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
    params.require(:estimate).permit(:name, :client_id, :area, :first_floor_height, :discount_by_stages,
      client_files_attributes: [:id, :asset_file_id, :_destroy],
      technical_files_attributes: [:id, :asset_file_id, :_destroy]
    )
  end
end
