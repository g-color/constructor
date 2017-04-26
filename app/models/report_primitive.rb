class ReportPrimitive < ApplicationRecord
  belongs_to :constructor_object
  belongs_to :estimate

  scope :by_constructor_object, -> (constructor_object_id) { where('constructor_object_id = ?', constructor_object_id) }

end
