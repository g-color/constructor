class ProductComposition < ApplicationRecord
  acts_as_paranoid

  belongs_to :product
  belongs_to :constructor_object

  validates :value, presence: true
  validates :constructor_object, presence: true
  validates :product, presence: true

  def update_report_primitivies(estimate, quantity)
    self.constructor_object.update_report_primitivies(estimate, quantity * self.value)
  end

end
