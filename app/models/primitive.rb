class Primitive < ConstructorObject
  acts_as_paranoid

  validates :name,        presence: true, length: { in: 2..256 }
  validates :unit_id,     presence: true
  validates :category_id, presence: true
  validates :price,       presence: true, numericality: { greater_than: 0 }
  validates :price,       float_with_precision_three: true

  def update_price
    parents.map(&:update_price)
  end

  def link
    Rails.application.routes.url_helpers.edit_primitive_path(self)
  end
end
