class Stage < ApplicationRecord
  NUMBER   = ['Первый', 'Второй', 'Третий']
  NAME     = ['Фундамент/коробка/кровля', 'Под отделку', 'Под чистовую внутреннюю отделку']
  CURRENT  = ['по первому этапу', 'по двум этапам', 'по трём этапам']
  DISCOUNT = ['по первому этапу', 'по второму этапу', 'по третьему этапу']
  ALL      = ['по первому этапу со скидкой', 'по двум этапам со скидкой', 'по трём этапам со скидкой']

  belongs_to :budget
  has_many   :stage_products

  scope :active, -> { where('price > 0') }

  def update_report_primitivies
    self.stage_products.each do |stage_product|
      stage_product.update_report_primitivies(self.budget)
    end
  end

  def get_primitives(with_work: true)
    result = {}
    self.stage_products.each do |stage_product|
      primitives = stage_product.get_primitives(with_work: with_work)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end
end
