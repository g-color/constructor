class Composition < ApplicationRecord
  acts_as_paranoid

  belongs_to :parent,   class_name: 'ConstructorObject', foreign_key: :parent_id
  belongs_to :children, class_name: 'ConstructorObject', foreign_key: :children_id

  default_scope { order(:id) }

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :value, float_with_precision_four: true
  validates :children, presence: true
  validates :children, parent_child: true

  def update_report_primitivies(estimate, quantity)
    children.update_report_primitivies(estimate, quantity * value)
  end

  def get_primitives(with_work: true)
    result = {}
    primitives = children.get_primitives(with_work: with_work)
    primitives.each do |key, val|
      result[key] = 0 if result[key].nil?
      result[key] += value * val
    end
    result
  end

  def to_s
    parent.name
  end

  def link
    Rails.application.routes.url_helpers.edit_composite_path(parent)
  end
end
