class StageProduct < ApplicationRecord
  belongs_to :stage
  belongs_to :product

  has_many :stage_product_sets

  scope :estimate_signed, ->              { joins(:stage => :estimate).where('estimates.signed') }
  scope :by_product,      -> (product_id) { where('product_id = ?', product_id) }

  def items
    if product.custom 
      return stage_product_sets.find_by(selected: true).stage_product_set_values.includes(:product_template, :constructor_object, constructor_object: [:unit]).map do |item|
        {
          name:   item.constructor_object.name,
          quantity: item.quantity,
          unit:   item.constructor_object.unit.name
        }
      end
    end
  end

  def update_report_primitivies(estimate)
    if self.product.custom
      product_set = self.stage_product_sets.find_by(selected: true)
      product_set.stage_product_set_values.each do |set_value|
        set_value.constructor_object.update_report_primitivies(estimate, self.quantity * set_value.quantity)
      end
    else
      self.product.update_report_primitivies(estimate, self.quantity)
    end
  end

  def get_primitives(undivisibilty_objects: false)
    result = {}
    if self.product.custom
      product_set = self.stage_product_sets.find_by(selected: true)
      product_set.stage_product_set_values.each do |set_value|
        primitives = set_value.get_primitives(undivisibilty_objects: undivisibilty_objects)
        primitives.each do |key, value|
          result[key] = 0 if result[key].nil?
          result[key] += value * self.quantity
        end
      end
    else
      primitives = self.product.get_primitives(undivisibilty_objects: undivisibilty_objects)
      primitives.each do |key, value|
        primitives[key] *= self.quantity
      end
      result = primitives
    end
    result
  end
end
