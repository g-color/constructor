class Stage < ApplicationRecord
  belongs_to :estimate
  has_many :stage_products

  def update_report_primitivies
    self.stage_products.each do |stage_product|
      stage_product.update_report_primitivies(self.estimate)
    end
  end
end
