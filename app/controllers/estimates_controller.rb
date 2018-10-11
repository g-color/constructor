class EstimatesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_products,  only: %i[new create edit update]
  before_action :get_engineers, only: %i[new create edit update]
  before_action :find_estimate, only: %i[edit update destroy]

  def index
    return redirect_to clients_path unless params[:client_id].present?

    @client    = Client.includes(:estimates).find(params[:client_id])
    @estimates = @client.estimates.order(created_at: :desc)
    @estimates = @estimates.where('lower(name) like ?', "%#{params[:name].downcase}%").order(created_at: :desc) if params[:name].present?
  end

  def new
    @estimate  = params[:client_id].present? ? Client.find(params[:client_id]).estimates.build : Estimate.new
    discount   = nil
    area       = 0
    price      = 0
      stages     = @estimate.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def create
    @estimate = Estimate.new(estimate_params.merge(user_id: current_user.id))
    params[:estimate][:discount_by_stages].each do |key, value|
      @estimate.discount_by_stages[key.to_i] = value.blank? ? 0 : value
    end
    if @estimate.save
      Services::Budget::UpdateJsonValues.new(
        budget: @estimate,
        stages: params[:json_stages]
      ).call

      @estimate.calc_parameters
      log_changes(Enums::Audit::Action::CREATE)

      @show_export_pdf = params[:export] == '1'
      flash[:notice] = 'Смета успешно сохранена'
      redirect_to edit_estimate_path(@estimate, export_pdf: params[:export] == '1')
    else
      discount = @estimate.discount_title
      area     = @estimate.area
      price    = @estimate.price
      stages   = JSON.parse(params[:json_stages])
      gon.push(get_json_values(discount, area, price, stages))
      render 'new'
    end
  end

  def edit
    discount     = @estimate.discount_title
    area         = @estimate.area
    price        = @estimate.price
    stages       = @estimate.get_stages
    gon.push(get_json_values(discount, area, price, stages).merge(export_pdf: params['export_pdf'] == 'true'))
  end

  def update
    params[:estimate][:discount_by_stages].each do |key, value|
      @estimate.discount_by_stages[key.to_i] = value.blank? ? 0 : value
    end
    if @estimate.update(estimate_params)
      Services::Budget::UpdateJsonValues.new(
        budget: @estimate,
        stages: params[:json_stages]
      ).call

      @estimate.calc_parameters
      log_changes(Enums::Audit::Action::UPDATE)
      flash[:notice] = 'Смета успешно сохранена'
      redirect_to edit_estimate_path(@estimate, export_pdf: params[:export] == '1')
    else
      discount = @estimate.discount_title
      area     = @estimate.area
      price    = @estimate.price
      stages   = JSON.parse(params[:json_stages])
      gon.push(get_json_values(discount, area, price, stages))
      render 'edit'
    end
  end

  def destroy
    client_id = @estimate.client_id
    @estimate.destroy
    log_changes(Enums::Audit::Action::DESTROY)
    redirect_to estimates_path(client_id: client_id)
  end

  def copy
    estimate     = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    new_estimate = Services::Budget::Copy.new(
      budget:    estimate,
      type:      :estimate,
      name:      params[:name],
      client_id: params[:client_id]
    ).call

    alert = new_estimate.errors.first[1] unless new_estimate.valid?
    redirect_to estimates_path(client_id: params[:client_id]), alert: alert
  end

  def propose
    estimate = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    return redirect_to edit_estimate_path(estimate) if estimate.already_proposed
    solution = Services::Budget::Copy.new(
      budget: estimate,
      type:   :solution
    ).call
    solution.update(proposed: true, proposer_id: current_user.id, client_id: nil)
    estimate.update(already_proposed: true)

    return redirect_to solutions_path if current_user.admin?
    alert_text = "Ваше предложение сделать смету #{estimate.name} готовым решением будет рассмотрено и одобрено в ближайшее время"
    redirect_to edit_estimate_path(estimate), alert: alert_text
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
    @estimate = Estimate.find(params[:estimate_id]).for_export_budget
    render pdf: 'export_pdf'
  end

  def export_doc
    estimate = Estimate.find(params[:estimate_id])
    respond_to do |format|
      format.html
      format.rtf { send_data estimate.rtf(current_user), filename: 'data.rtf' }
    end
  end

  def estimates_engineer
    @estimate = Estimate.find(params[:estimate_id])
    engineer = User.find_by(id: params[:engineer])
    signed = params[:signed]

    return if @estimate.nil? || engineer.nil?

    @estimate.user = current_user
    if signed.present?
      @estimate.signed = true
      @estimate.signing_date = Time.now
    end
    @estimate.save

    salary_path = @estimate.export_salary(engineer)
    primitives_path = @estimate.export_primitives

    @estimate.send_email_engineer(params[:engineer], salary_path, primitives_path)

    render json: {
      engineer: engineer,
      signed:   signed
    }
  end

  private

  def find_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(
      :name,
      :client_id,
      :area,
      :price,
      :discount_title,
      :discount_by_stages,
      :first_floor_height,
      :second_floor_height_min,
      :second_floor_height_max,
      :third_floor_height_min,
      :third_floor_height_max,
      client_files_attributes:    %i[id asset_file_id _destroy],
      technical_files_attributes: %i[id asset_file_id _destroy]
    )
  end

  def get_json_values(discount, area, price, stages, _second_floor = false)
    {
      expense:  { percent: Expense.sum(:percent) },
      discount: { name: discount, values: @estimate.discount_by_stages },
      estimate: {
        area:         area,
        price:        price,
        second_floor: @estimate.second_floor_height_min.nil? ? false : @estimate.second_floor_height_min > 0
      },
      products: @products,
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

  def get_engineers
    @engineers = User.engineers
  end

  def log_changes(action)
    Services::Audit::Log.new(
      user:        current_user,
      object_type: 'estimate',
      object_name: @estimate.name,
      object_link: @estimate.link,
      action:      action
    ).call
  end
end
