class ProductComposition < ApplicationRecord
  acts_as_paranoid

  default_scope { order(id: :asc) }

  belongs_to :product
  belongs_to :constructor_object

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :value, float_with_precision_four: true
  validates :constructor_object, presence: true
  validates :product, presence: true

  def update_report_primitivies(estimate, quantity)
    self.constructor_object.update_report_primitivies(estimate, quantity * self.value)
  end

  def get_primitives(with_work: true)
    result = {}
    primitives = self.constructor_object.get_primitives(with_work: with_work)
    primitives.each do |key, val|
      primitives[key] *= self.value
    end
    primitives
  end

  def to_s
    product&.name
  end

  def link
    product ? Rails.application.routes.url_helpers.edit_product_path(product) : ''
  end
end
