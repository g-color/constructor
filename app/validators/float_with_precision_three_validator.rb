class FloatWithPrecisionThreeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Должно быть не более трех знаков после запятой" if value.present? && (value*1000).to_i != value*1000
  end
end