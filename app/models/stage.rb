class Stage < ApplicationRecord
  belongs_to :estimate
  has_many :stage_products
end
