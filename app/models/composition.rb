class Composition < ApplicationRecord
  acts_as_paranoid

  belongs_to :parent,
            class_name: "ConstructorObject",
            foreign_key: :parent_id

  belongs_to :children,
            class_name: "ConstructorObject",
            foreign_key: :children_id

  validates :value, presence: true
  validates :children, presence: true
  validates :children, parent_child: true

  def update_report_primitivies(estimate, quantity)
    self.children.update_report_primitivies(estimate, quantity * self.value)
  end

  def get_primitives(undivisibilty_objects: false)
    result = {}
    primitives = self.children.get_primitives(undivisibilty_objects: undivisibilty_objects)
    primitives.each do |key, val|
      result[key] = 0 if result[key].nil?
      result[key] += value * val
    end
    result
  end

end
