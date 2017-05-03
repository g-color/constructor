class Primitive < ConstructorObject
  acts_as_paranoid
  audited

  validates :name,        presence: true
  validates :unit_id,     presence: true
  validates :category_id, presence: true
  validates :price,       presence: true

  def update_price
    parents.map(&:update_price)
  end

  def link
    Rails.application.routes.url_helpers.edit_primitive_path(self)
  end
end
