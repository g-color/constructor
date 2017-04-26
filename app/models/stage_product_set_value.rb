class StageProductSetValue < ApplicationRecord
  belongs_to :stage_product_set
  belongs_to :product_template
  belongs_to :constructor_object
end
