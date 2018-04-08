class Estimate < Budget
  acts_as_paranoid

  validates :client, presence: true
  validates :name,   uniqueness: {
    scope: :client,
    message: "Название должно быть уникально для клиента",
    case_sensitive: false
  }

  belongs_to :client

  after_save :update_report_primitivies

  def get_primitives(with_work: true)
    result = {}
    self.stages.each do |stage|
      primitives = stage.get_primitives(with_work: with_work)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end

  def export_salary(engineer)
    file_path  = Rails.root.join("export/xls/engineer_salary_#{id}_#{Date.today}.xlsx")
    primitives = get_primitives
    workbook   = WriteXLSX.new(file_path)

    # Add a worksheet
    worksheet = workbook.add_worksheet

    worksheet.write(0, 0, 'Объект:')

    worksheet.write(2, 0, 'Наименование')
    worksheet.write(2, 1, 'ед. изм.')
    worksheet.write(2, 2, 'Количество')
    worksheet.write(2, 3, 'Расценка, руб.')
    worksheet.write(2, 4, 'Стоимость, руб.')

    row = 3
    primitives.each do |key, value|
      primitive = ConstructorObject.find(key.to_i)
      next unless primitive.category.id == ENV['WORK_CATEGORY'].to_i

      worksheet.write(row, 0, primitive.name)
      worksheet.write(row, 1, primitive.unit.name)
      worksheet.write(row, 2, value)
      worksheet.write(row, 3, primitive.price)
      worksheet.write(row, 4, "=C#{row + 1}*D#{row + 1}")
      row += 1
    end

    row += 1

    worksheet.write("D#{row}", 'Итого:')
    worksheet.write("E#{row}", "=SUM(E4:E#{row - 1})")

    row += 1

    worksheet.write("A#{row}", 'В обязанности рабочего входят:
      - погрузочно-разгрузочные работы при приеме-передаче материала
      - выполнять работы добросовестно и качественно, в соответствии с предписаниями, соблюдением технологии. Любые отклонения могут быть только по согласованию с технадзором
      - следить за чистотой и порядком на объекте
      - ответственность за инструмент и материал
      - сообщать технадзору при обнаружении несостыковок в схемах сборки
      - сообщать технадзору, если клиент обратился с просьбой о дополнительных работах, с просьбой внести изменения в проект
      - при сдаче объекта рабочий должен:
      1. сдать весь оставщийся материал, крепеж и инструмент (если таковой выдала фирма) фирме
      2. убрать объект и подготовить мусор к вывозу')

    row += 5

    worksheet.write("A#{row}", 'Технадзор:')
    worksheet.write("B#{row}", "#{engineer.full_name} #{engineer.phone}")

    # Write xlsx file to disk.
    workbook.close

    file_path
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

  def send_email_engineer(engineer_id, salary_path)
    EstimateMailer.export_engineer(engineer_id, id, salary_path).deliver_later
  end

  def link
    Rails.application.routes.url_helpers.edit_estimate_path(self)
  end
end
