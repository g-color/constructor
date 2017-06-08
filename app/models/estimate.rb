class Estimate < Budget
  acts_as_paranoid
  audited

  validates :client, presence: true
  validates :name,   uniqueness: {
    scope: :client,
    message: "Название должно быть уникально для клиента",
    case_sensitive: false
  }

  belongs_to :client

  after_save :update_report_primitivies

  def get_primitives(undivisibilty_objects: false)
    result = {}
    self.stages.each do |stage|
      primitives = stage.get_primitives(undivisibilty_objects: undivisibilty_objects)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end

  def for_export_salary(engineer)
    primitives = get_primitives
    view       = ActionView::Base.new(ActionController::Base.view_paths, {})
    locals     = {
      primitives: primitives,
      engineer:   engineer,
      number:     3
    }
    view.render(partial: 'budgets/engineer_export_salary.xls.erb', locals: locals, layout: false)
  end

  def for_export_primitives
    stage_products = []
    stages.each do |stage|
      stage_products += stage.stage_products.to_a
    end

    result = {}
    products = []
    stage_products.each do |stage_product|
      primitives = stage_product.get_primitives
      product = stage_product.product
      products << product.name
      primitives.each do |p, quantity|
        primitive = ConstructorObject.find(p)
        if primitive.category.id != ENV['WORK_CATEGORY'].to_i && primitive.category.id != ENV['STOCK_CATEGORY'].to_i
          result[primitive.category.name] = {} if result[primitive.category.name].blank?
          if result[primitive.category.name][primitive.name].nil?
            result[primitive.category.name][primitive.name]        = {}
            result[primitive.category.name][primitive.name][:unit] = primitive.unit.name
          end
          result[primitive.category.name][primitive.name][product.name]  = 0 if result[primitive.category.name][primitive.name][product.name].nil?
          result[primitive.category.name][primitive.name][product.name] += quantity
        end
      end
    end
    products = products.uniq

    view       = ActionView::Base.new(ActionController::Base.view_paths, {})
    locals     = {
      products: products,
      result:   result,
      number:   3,
      column:   get_column_csv(products.size + 1)
    }
    view.render(partial: 'budgets/engineer_export_primitives.xls.erb', locals: locals, layout: false)
  end

  def get_column_csv(num)
    col = ''
    while num > 0
      col = (num % 26 + 'A'.ord).chr + col
      num /= 26
    end
    col
  end

  def send_email_engineer(engineer_id)
    EstimateMailer.export_engineer(engineer_id, self.id).deliver_now
  end

  def link
    Rails.application.routes.url_helpers.edit_estimate_path(self)
  end
end
