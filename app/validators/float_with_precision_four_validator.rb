class FloatWithPrecisionFourValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Должно быть не более четырех знаков после запятой" if value.present? && (value*10000).to_i != value*10000
  end
end