class Stage < ApplicationRecord
  belong_to :estimate
  has_many :stage_products
end
