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

  scope :filter_name, -> (name)        { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :category,    -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :active,      ->               { where('deleted_at IS NULL') }


  accepts_nested_attributes_for :compositions, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :name, unique_name: true

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

  def is_primitive?
    self.type == 'Primitive'
  end

  def work_primitive?
    is_primitive? && category_id == ENV['WORK_CATEGORY'].to_i
  end

  def update_report_primitivies(estimate, quantity)
    if is_primitive?
      ReportPrimitive.create(
        constructor_object: self,
        amount: quantity,
        signing_date: estimate.signing_date,
        estimate: estimate
      )
    else
      self.compositions.each do |composition|
        composition.update_report_primitivies(estimate, quantity)
      end
    end
  end

  def get_primitives(undivisibilty_objects: true)
    result = {}
    if is_primitive? || !self.divisibility
      result = {
        self.id => 1
      }
    else
      self.compositions.each do |composition|
        primitives = composition.get_primitives(undivisibilty_objects: undivisibilty_objects)
        primitives.each do |key, value|
          result[key] = 0 if result[key].nil?
          result[key] += value
        end
      end
    end
    result
  end

  def autocomplete_name
    type_name = self.type == 'Primitive' ? 'Примитив' : 'Объект'
    "#{name} (#{type_name})"
  end
end
