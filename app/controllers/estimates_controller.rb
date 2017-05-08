class EstimatesController < ApplicationController
  before_action :get_products,  only: [:new,  :create, :edit, :update]
  before_action :find_estimate, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    return redirect_to clients_path unless params[:client_id].present?

    @client    = Client.includes(:estimates).find(params[:client_id])
    @estimates = @client.estimates
    @estimates = @estimates.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
  end

  def new
    @engineers = User.engineers
    @estimate = Estimate.new
    @estimate = Client.find(params[:client_id]).estimates.build if params[:client_id].present?

    discount  = nil
    area      = 0
    price     = 0
    stages    = @estimate.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def create
    @engineers = User.engineers
    @estimate = Estimate.new(estimate_params.merge(user_id: current_user.id))
    params[:estimate][:discount_by_stages].each do |key, value|
      @estimate.discount_by_stages[key.to_i] = value
    end

    if @estimate.save
      @estimate.update_json_values(params[:json_stages])
      @estimate.calc_parameters
      redirect_to estimates_path(client_id: @estimate.client_id)
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
    @engineers = User.engineers
    discount = @estimate.discount_title
    area     = @estimate.area
    price    = @estimate.price
    stages   = @estimate.get_stages
    gon.push(get_json_values(discount, area, price, stages))
  end

  def update
    params[:estimate][:discount_by_stages].each do |key, value|
      @estimate.discount_by_stages[key.to_i] = value
    end
    if @estimate.update(estimate_params)
      @estimate.update_json_values(params[:json_stages])
      @estimate.calc_parameters
      redirect_to estimates_path(client_id: @estimate.client_id)
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
    redirect_to estimates_path(client_id: client_id)
  end

  def copy
    estimate     = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    new_estimate = estimate.copy(type: :estimate, name: params[:name], client_id: params[:client_id])

    alert = new_estimate.errors.first[1] unless new_estimate.valid?
    redirect_to estimates_path(client_id: params[:client_id]), alert: alert
  end

  def propose
    estimate = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    solution = estimate.copy(type: :solution)
    solution.update(proposed: true, proposer_id: current_user.id, client_id: nil)

    redirect_to solutions_path
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
    render pdf: "export_pdf"
  end

  def export_doc
    @estimate = Estimate.find(params[:estimate_id]).for_export_budget
    respond_to do |format|
      format.docx do
        return render docx: 'export_doc', filename: 'export_doc.docx'
      end
    end
  end

  def estimates_engineer
    @estimate = Estimate.find(params[:estimate_id])
    engineer = User.find_by(id: params[:engineer])
    signed = params[:signed]

    @estimate.user = current_user
    if signed.present?
      @estimate.signed = true
      @estimate.signing_date = Time.now
    end
    @estimate.save

    @estimate.send_email_engineer(params[:engineer])
    @data = @estimate.for_export_zp
    pdf = WickedPdf.new.pdf_from_string(render_to_string('export_zp'))
    File.open(Rails.root.join('pdfs',"Ведомость ЗП на объект.pdf"), 'wb') do |file|
      file << pdf
    end

    @data = @estimate.for_export_primitives
    pdf = WickedPdf.new.pdf_from_string(render_to_string('export_primitives'))
    File.open(Rails.root.join('pdfs',"Перечень материалов на объект.pdf"), 'wb') do |file|
      file << pdf
    end

    render json: {
      engineer: engineer,
      signed: signed
    }
  end

  private

  def find_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(:name, :client_id, :area, :price,
      :discount_title, :discount_by_stages, :first_floor_height,
      :second_floor_height_min, :second_floor_height_max, :third_floor_height_min,
      :third_floor_height_max,
      client_files_attributes:    [:id, :asset_file_id, :_destroy],
      technical_files_attributes: [:id, :asset_file_id, :_destroy],
    )
  end

  def get_json_values(discount, area, price, stages)
    {
      expense: { percent: Expense.sum(:percent) },
      products: @products,
      discount: { name: discount, values: @estimate.discount_by_stages },
      estimate: { area: area,     price:  price },
      stages: stages,
    }
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
