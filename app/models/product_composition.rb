class ProductComposition < ApplicationRecord
  acts_as_paranoid

  belongs_to :product
  belongs_to :constructor_object

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :constructor_object, presence: true
  validates :product, presence: true

  def update_report_primitivies(estimate, quantity)
    self.constructor_object.update_report_primitivies(estimate, quantity * self.value)
  end

  def get_primitives(undivisibilty_objects: false)
    result = {}
    primitives = self.constructor_object.get_primitives(undivisibilty_objects: undivisibilty_objects)
    primitives.each do |key, val|
      primitives[key] *= self.value
    end
    primitives
  end

end
