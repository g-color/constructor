class FloatWithPrecisionTwoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Должно быть не более двух знаков после запятой" if value.present? && (value*100).to_i != value*100
  end
end