class ProductSet < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  has_many :product_template_sets
end
