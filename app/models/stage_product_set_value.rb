class StageProductSetValue < ApplicationRecord
  belongs_to :stage_product_set
  belongs_to :product_template
  belongs_to :constructor_object

  def get_primitives(undivisibilty_objects: false)
    primitives = self.constructor_object.get_primitives(undivisibilty_objects: undivisibilty_objects)
    primitives.each do |key, value|
      primitives[key] *= self.quantity
    end
    primitives
  end
end
