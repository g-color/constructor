class ReportPrimitive < ApplicationRecord
  belongs_to :constructor_object
  belongs_to :estimate

  scope :by_constructor_object, -> (constructor_object_id) { where('constructor_object_id = ?', constructor_object_id) }
  scope :date_start,  -> (date_start) { where('signing_date >= ?', date_start.to_datetime - 1.day) if date_start.present? }
  scope :date_end,    -> (date_end)   { where('signing_date <= ?', date_end.to_datetime + 1.day) if date_end.present? }

end
