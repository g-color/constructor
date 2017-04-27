class EstimatesController < ApplicationController
  before_action :get_products, only: [:new, :create, :edit, :update]
  before_action :find_estimate, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    return redirect_to clients_path unless params[:client_id].present?

    @client    = Client.includes(:estimates).find(params[:client_id])
    @estimates = @client.estimates
    @estimates = @estimates.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
  end

  def new
    if params[:client_id].present?
      @estimate = Client.find(params[:client_id]).estimates.build
    else
      @estimate = Estimate.new
    end

    gon.push(
      expense: Expense.find(ENV['EXPENSE_ID']),
      products: @products,
      discount: {
        name: nil,
        values: @estimate.discount_by_stages
      },
      estimate: {
        area:  0,
        price: 0,
      },
      stages: @estimate.get_stages
    )
  end

  def create
    @estimate = Estimate.new(estimate_params)
    if params[:estimate][:discount_by_stages].present?
      params[:estimate][:discount_by_stages].each do |key, value|
        @estimate.discount_by_stages[key.to_i] = value
      end
    end

    if @estimate.save
      @estimate.update_json_values(params[:json_stages])
      @estimate.calc_parameters
      redirect_to estimates_path(client_id: @estimate.client_id)
    else
      gon.push(
        expense: Expense.find(ENV['EXPENSE_ID']),
        products: @products,
        discount: {
          name: nil,
          values: @estimate.discount_by_stages
        },
        estimate: {
          area:  @estimate.area,
          price: @estimate.price,
        },
        stages: JSON.parse(params[:json_stages])
      )
      render 'new'
    end
  end

  def edit
    gon.push(
      expense: Expense.find(ENV['EXPENSE_ID']),
      products: @products,
      discount: {
        name: @estimate.discount_title,
        values: @estimate.discount_by_stages
      },
      estimate: {
        area:  @estimate.area,
        price: @estimate.price,
      },
      stages: @estimate.get_stages,
    )
  end

  def update
    if @estimate.update(estimate_params)
      @estimate.update_json_values(params[:json_stages])
      @estimate.calc_parameters
      redirect_to estimates_path(client_id: @estimate.client_id)
    else
      gon.push(
        expense: Expense.find(ENV['EXPENSE_ID']),
        products: @products,
        discount: {
          name: @estimate.discount_title,
          values: @estimate.discount_by_stages
        },
        estimate: {
          area:  @estimate.area,
          price: @estimate.price,
        },
        stages: JSON.parse(params[:json_stages]),
      )
      render 'edit'
    end
  end

  def destroy
    client_id = @estimate.client_id
    @estimate.destroy
    redirect_to estimates_path(client_id: client_id)
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
    params.require(:estimate).permit(:name, :client_id, :area,
      :first_floor_height, :discount_title, :discount_by_stages, :price,
      client_files_attributes:    [:id, :asset_file_id, :_destroy],
      technical_files_attributes: [:id, :asset_file_id, :_destroy],
    )
  end

  def get_products
    products = Product.includes(:unit)
    @products = [
      products.where(stage: 1).map_for_estimate,
      products.where(stage: 2).map_for_estimate,
      products.where(stage: 3).map_for_estimate,
    ]
  end
end
