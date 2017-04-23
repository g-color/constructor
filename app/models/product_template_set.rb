class ProductTemplateSet < ApplicationRecord
  acts_as_paranoid

  belongs_to :product
  belongs_to :product_template
  belongs_to :product_set
  belongs_to :constructor_object

  validates :product, presence: true
end
