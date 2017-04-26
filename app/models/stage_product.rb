class StageProduct < ApplicationRecord
  belongs_to :stage
  belongs_to :product

  has_many :stage_product_sets

  scope :estimate_signed, ->              { joins(:stage => :estimate).where('estimates.signed') }
  scope :by_product,      -> (product_id) { where('product_id = ?', product_id) }

  def update_report_primitivies(estimate)
    if self.product.custom
      product_set = self.stage_product_sets.find_by(selected: true)
      product_set.stage_product_set_values.each do |set_value|
        set_value.constructor_object.update_report_primitivies(estimate, self.quantity * set_value.quantity)
      end
    else
      self.product.update_report_primitivies(estimate, self.quantity)
    end
  end
end
