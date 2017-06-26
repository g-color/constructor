class StageProductSetValue < ApplicationRecord
  belongs_to :stage_product_set
  belongs_to :product_template
  belongs_to :constructor_object

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def get_primitives(with_work: true)
    primitives = self.constructor_object.get_primitives(with_work: with_work)
    primitives.each do |key, value|
      primitives[key] *= self.quantity
    end
    primitives
  end
end
