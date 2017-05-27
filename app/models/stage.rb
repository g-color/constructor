class Stage < ApplicationRecord
  NUMBER = ['Первый', 'Второй', 'Третий']
  NAME   = [ 'Фундамент/коробка/кровля', 'Под отделку', 'Под чистовую внутреннюю отделку' ]
  CURRENT = ['по первому этапу', 'по второму этапу', 'по третьему этапу']
  ALL = ['по первому этапу', 'по двум этапам', 'по трем этапам']

  belongs_to :budget
  has_many   :stage_products

  scope :active, -> { where('price > 0')}

  def update_report_primitivies
    self.stage_products.each do |stage_product|
      stage_product.update_report_primitivies(self.estimate)
    end
  end

  def get_primitives(undivisibilty_objects: false)
    result = {}
    self.stage_products.each do |stage_product|
      primitives = stage_product.get_primitives(undivisibilty_objects: undivisibilty_objects)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end
end
