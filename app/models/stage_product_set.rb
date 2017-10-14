class StageProductSet < ApplicationRecord
  belongs_to :stage_product
  belongs_to :product_set
  has_many :stage_product_set_values

  before_destroy :clear_relationship

  def clear_relationship
    stage_product_set_values.each(&:destroy)
  end
end
