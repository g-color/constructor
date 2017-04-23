class ParentChildValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    items = value.all_items
    parents = value.all_parents
    parents << record.parent
    record.errors[:value] << (options[:message] || "circle") if (items & parents).present?
  end
end