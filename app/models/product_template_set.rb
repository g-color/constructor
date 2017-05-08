class ProductTemplateSet < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :product
  belongs_to :product_template
  belongs_to :product_set
  belongs_to :constructor_object

  validates :product, presence: true

  def to_s
    product.name
  end

  def link
    Rails.application.routes.url_helpers.edit_product_path(product)
  end
end
