class Composite < ConstructorObject
  acts_as_paranoid
  audited except: :price

  validates :unit_id, presence: true
  validates :category_id, presence: true

  def update_price
    self.price                 = 0
    self.price_without_work    = 0

    compositions.each do |composition|
      children                 = composition.children
      children_price           = composition.value * children.price
      self.price              += children_price
      self.price_without_work += children_price unless children.work_primitive?
    end
    self.save
    parents.map(&:update_price)
  end

  def link
    Rails.application.routes.url_helpers.edit_composite_path(self)
  end
end
