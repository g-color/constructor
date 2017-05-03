class EstimatesController < ApplicationController
  before_action :get_products,  only: [:new,  :create, :edit, :update]
  before_action :find_estimate, only: [:edit, :update, :destroy, :estimates_engineer]
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

      return redirect_to estimates_export_pdf_path(@estimate.id) if params[:export] == 'pdf'
      return redirect_to estimates_export_doc_path(@estimate.id) if params[:export] == 'doc'
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
      if params[:export] == 'engineer'
        export_engineer(params)
      end
      return redirect_to estimate_export_pdf_path(@estimate.id) if params[:export] == 'pdf'
      return redirect_to estimate_export_doc_path(@estimate.id) if params[:export] == 'doc'
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
    estimate = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    client   = Client.find(params[:client_id])
    estimate.copy(name: params[:name], client: client)

    redirect_to estimates_path(client_id: client.id)
  end

  def propose
    estimate = Estimate.includes(:stages, :client_files, :technical_files).find(params[:estimate_id])
    solution = estimate.copy(name: estimate.name, client: estimate.client)

    redirect_to estimates_path(client_id: estimate.client_id)
  end

  def files
    f = AssetFile.create(data: params[:file])
    render json: {
      id:   f.id,
      name: f.data_file_name,
      src:  f.image? ? f.data.url : ActionController::Base.helpers.asset_url('file-icon.png')
    }
  end

  def export_engineer(params)
    @estimate.send_email_engineer(params[:engineer])
    primitives = @estimate.get_primitives
    @data = []
    @res = 0
    primitives.each do |key, value|
      primitive = Primitive.find(key.to_i)
      if primitive.category.id == ENV['WORK_CATEGORY'].to_i
        @data << {
          name: primitive.name,
          unit: primitive.unit.name,
          price: primitive.price,
          quantity: value,
          sum: value * primitive.price
        }
        @res += value * primitive.price
      end
    end
    pdf = WickedPdf.new.pdf_from_string(render_to_string('export_zp'))
    save_path = Rails.root.join('pdfs',"Ведомость ЗП на объект.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    stages = @estimate.stages
    stage_products = []
    stages.each do |stage|
      stage_products += stage.stage_products.to_a
    end

    @result = {}
    @products = []
    stage_products.each do |stage_product|
      primitives = stage_product.get_primitives
      product = stage_product.product
      @products << product.name
      primitives.each do |p, quantity|
        primitive = Primitive.find(p)
        if primitive.category.id != ENV['WORK_CATEGORY'].to_i && primitive.category.id != ENV['STOCK_CATEGORY'].to_i
          if @result[primitive.name].nil?
            @result[primitive.name] = {}
            @result[primitive.name][:all] = 0
            @result[primitive.name][:unit] = primitive.unit.name
          end
          @result[primitive.name][product.name] = 0 if @result[primitive.name][product.name].nil?
          @result[primitive.name][product.name] += quantity
          @result[primitive.name][:all] += quantity
        end
      end
    end

    @products = @products.uniq

    puts "\n\n\n\n\n", @result, "\n\n\n\n"

    pdf = WickedPdf.new.pdf_from_string(render_to_string('export_primitives'))
    save_path = Rails.root.join('pdfs',"Перечень материалов на объект.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end


  end

  def export_pdf
    @estimate = data_for_export(Estimate.find(params[:estimate_id]))
    render pdf: "export_pdf"
  end

  respond_to :docx

  def export_doc
    @estimate = data_for_export(Estimate.find(params[:estimate_id]))
    respond_to do |format|
      format.docx do
        return render docx: 'export_doc', filename: 'export_doc.docx'
      end
    end
  end

  def estimates_engineer(params)
    engineer = User.find(params[:engineer])
    signed = params[:signed]

    @estimate.user = current_user
    if signed.present?
      @estimate.signed = true
      @estimate.signing_date = Time.now
    end
    @estimate.save

    render json: {
      engineer: engineer,
      signed: signed
    }
  end

  private

  def data_for_export(estimate)
    {
      discount_title: estimate.discount_title,
      discount_amount: estimate.discount_amount,
      price_by_stage_aggregated: estimate.price_by_stage_aggregated,
      price_by_area_per_stage: estimate.price_by_area_per_stage,
      price_by_stage_aggregated_discounted: estimate.price_by_stage_aggregated_discounted,
      price_by_area_per_stage_discounted: estimate.price_by_area_per_stage_discounted,
      name: estimate.name,
      date: estimate.created_at,
      area:  estimate.area,
      price: estimate.price,
      first_floor_height: estimate.first_floor_height,
      second_floor_height_min: estimate.second_floor_height_min,
      second_floor_height_max: estimate.second_floor_height_max,
      third_floor_height_min: estimate.third_floor_height_min,
      third_floor_height_max: estimate.third_floor_height_max,
      stages: estimate.stages.includes(:stage_products).map do |stage|
        {
          number:      stage.number,
          price:       stage.price,
          total_price: stage.total_price,
          products:    stage.stage_products.includes(:stage_product_sets, :product, product: [:unit] ).map do |stage_product|
            {
              name:               stage_product.product.name,
              description:        stage_product.product.description,
              display_components: stage_product.product.display_components,
              custom:             stage_product.product.custom,
              with_work:          stage_product.with_work,
              unit:               stage_product.product.unit.name,
              price_result:       stage_product.with_work ? stage_product.price_with_work : stage_product.price_without_work,
              quantity:           stage_product.quantity,
              set_name:           stage_product.product.custom ? stage_product.stage_product_sets.find_by(selected: true).product_set.name : '',
              sets:               stage_product.product.custom ? estimate.get_stage_product_set(stage_product) : [],
              items:              stage_product.items
            }
          end
        }
      end
    }
  end

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

  def get_json_values(discount, area, price, stages)
    {
      expense: Expense.find(ENV['EXPENSE_ID']),
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
