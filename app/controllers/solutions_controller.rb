class SolutionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_products,  only:   %i[new create edit update]
  before_action :find_solution, only:   %i[show edit update destroy]
  before_action :check_ability, except: %i[show index copy]

  def index
    @solutions = Solution.all
    @solutions = @solutions.where('lower(name) like ?', "%#{params[:name].downcase}%") if params[:name].present?
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
      Services::Budget::UpdateJsonValues.new(
        budget: @solution,
        stages: params[:json_stages]
      ).call
      @solution.calc_parameters
      log_changes(Enums::Audit::Action::CREATE)
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
      Services::Budget::UpdateJsonValues.new(
        budget: @solution,
        stages: params[:json_stages]
      ).call

      @solution.calc_parameters
      log_changes(Enums::Audit::Action::UPDATE)
      if params[:accept] == 'true'
        redirect_to solution_accept_path(@solution)
      else
        redirect_to solutions_path
      end
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
    log_changes(Enums::Audit::Action::DESTROY)
    redirect_to solutions_path
  end

  def accept
    Solution.find(params[:solution_id]).update(proposed: false)
    redirect_to solutions_path
  end

  def copy
    solution = Solution.includes(:stages, :client_files, :technical_files).find(params[:solution_id])
    new_estimate = Services::Budget::Copy.new(
      budget:    solution,
      type:      :estimate,
      name:      params[:name],
      client_id: params[:client_id]
    ).call

    alert = new_estimate.errors.first[1] unless new_estimate.valid?
    redirect_to estimates_path(client_id: params[:client_id]), alert: alert
  end

  def files
    f = AssetFile.create(data: params[:file])
    render json: {
      id:   f.id,
      name: f.data_file_name,
      src:  f.image? ? f.data.url : ActionController::Base.helpers.asset_url('file-icon.png')
    }
  end

  def export_pdf
    @solution = Solution.find(params[:solution_id]).for_export_budget
    # render pdf: 'export_pdf'
  end

  private

  def check_ability
    redirect_to solutions_path unless can?(:manage, Solution)
  end

  def find_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(
      :name,
      :client_id,
      :area,
      :url,
      :first_floor_height,
      :discount_title,
      :discount_by_stages,
      :price,
      client_files_attributes:    %i[id asset_file_id _destroy],
      technical_files_attributes: %i[id asset_file_id _destroy]
    )
  end

  def get_json_values(discount, area, price, stages)
    {
      expense:  { percent: Expense.sum(:percent) },
      products: @products,
      discount: { name: discount, values: @solution.discount_by_stages },
      estimate: { area: area,     price:  price },
      stages:   stages
    }
  end

  def get_products
    products = Product.includes(:unit)
    @products = [
      products.where(stage: 1).map_for_estimate,
      products.where(stage: 2).map_for_estimate,
      products.where(stage: 3).map_for_estimate
    ]
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'solution',
      object_name: @solution.name,
      object_link: @solution.link,
      action:      action
    ).call
  end
end
