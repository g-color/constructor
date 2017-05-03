class Composite < ConstructorObject
  acts_as_paranoid
  audited except: :price

  validates :name, presence: true
  validates :unit_id, presence: true
  validates :category_id, presence: true

  def update_price
    self.price = 0
    compositions.each do |composition|
      self.price += composition.value * composition.children.price
    end
    self.save
    parents.map(&:update_price)
  end

  def link
    Rails.application.routes.url_helpers.edit_composite_path(self)
  end
end
