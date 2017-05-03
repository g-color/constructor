class ConstructorObject < ApplicationRecord
  belongs_to :unit
  belongs_to :category

  has_many :compositions,
              foreign_key: :parent_id,
              class_name: "Composition"

  has_many :parent_compositions,
              foreign_key: :children_id,
              class_name: "Composition"

  has_and_belongs_to_many :items,
              class_name: "ConstructorObject",
              join_table: :compositions,
              foreign_key: :parent_id,
              association_foreign_key: :children_id

  has_and_belongs_to_many :parents,
              class_name: "ConstructorObject",
              join_table: :compositions,
              foreign_key: :children_id,
              association_foreign_key: :parent_id

  accepts_nested_attributes_for :compositions, reject_if: :all_blank, allow_destroy: true

  def to_s
    name
  end

  def constructor_object_id
    id
  end

  def constructor_object
    self
  end

  def all_items
    ans = []
    items.each do |item|
      ans << item
      ans += item.all_items
    end
    ans.uniq
  end

  def all_parents
    ans = []
    parents.each do |parent|
      ans << parent
      ans += parent.all_parents
    end
    ans.uniq
  end

end
