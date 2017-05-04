class SolutionsController < ApplicationController
  before_action :get_products,  only: [:new,  :create, :edit, :update]
  before_action :find_solution, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @solutions = Solution.all
    @solutions = @solutions.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
  end

  def show
    discount = @solution.discount_title
    area     = @solution.area
    price    = @solution.price
    stages   = @solution.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def new
    @solution = Solution.new

    discount  = nil
    area      = 0
    price     = 0
    stages    = @solution.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def create
    @solution = Solution.new(solution_params)
    params[:solution][:discount_by_stages].each do |key, value|
      @solution.discount_by_stages[key.to_i] = value
    end

    if @solution.save
      @solution.update_json_values(params[:json_stages])
      @solution.calc_parameters
      redirect_to solutions_path
    else
      discount = @solution.discount_title
      area     = @solution.area
      price    = @solution.price
      stages   = JSON.parse(params[:json_stages])
      gon.push(get_json_values(discount, area, price, stages))
      render 'new'
    end
  end

  def edit
    discount = @solution.discount_title
    area     = @solution.area
    price    = @solution.price
    stages   = @solution.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def update
    params[:solution][:discount_by_stages].each do |key, value|
      @solution.discount_by_stages[key.to_i] = value
    end
    if @solution.update(solution_params)
      @solution.update_json_values(params[:json_stages])
      @solution.calc_parameters
      redirect_to solutions_path
    else
      discount = @solution.discount_title
      area     = @solution.area
      price    = @solution.price
      stages   = JSON.parse(params[:json_stages])
      gon.push(get_json_values(discount, area, price, stages))
      render 'edit'
    end
  end

  def destroy
    @solution.destroy
    redirect_to solutions_path
  end

  def accept
    Solution.find(params[:solution_id]).update(proposed: false)
    redirect_to solutions_path
  end

  def copy
    solution = Solution.includes(:stages, :client_files, :technical_files).find(params[:solution_id])
    estimate = solution.copy(type: :estimate, name: params[:name], client_id: params[:client_id])

    alert = new_estimate.errors.first[1] unless new_estimate.valid?
    redirect_to estimates_path(client_id: client.id), alert: alert
  end

  def files
    f = AssetFile.create(data: params[:file])
    render json: {
      id:   f.id,
      name: f.data_file_name,
      src:  f.image? ? f.data.url : ActionController::Base.helpers.asset_url('file-icon.png')
    }
  end

  private

  def find_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(:name, :client_id, :area, :url,
      :first_floor_height, :discount_title, :discount_by_stages, :price,
      client_files_attributes:    [:id, :asset_file_id, :_destroy],
      technical_files_attributes: [:id, :asset_file_id, :_destroy],
    )
  end

  def get_json_values(discount, area, price, stages)
    {
      expense:  { percent: Expense.sum(:percent) },
      products: @products,
      discount: { name: discount, values: @solution.discount_by_stages },
      estimate: { area: area,     price:  price },
      stages:   stages,
    }
  end

  def get_products
    @products = []
    (1..3).each do |i|
      @products.push(Product.includes(:unit).where(stage: 1).map_for_estimate)
    end
  end
end
