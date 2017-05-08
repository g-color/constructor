class ProductSet < ApplicationRecord
  acts_as_paranoid
  audited

  validates :name, presence: true
  has_many  :product_template_sets

  def to_s
    get_product
    @product.name
  end

  def link
    get_product
    Rails.application.routes.url_helpers.edit_product_path(@product)
  end

  def get_product
    @product ||= product_template_sets.where(product_template: self).first.product
  end
end
