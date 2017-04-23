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

end
