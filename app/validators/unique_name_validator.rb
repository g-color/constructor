class UniqueNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "Такое наименование уже существует" if record.name_changed? && (ConstructorObject.exists?(name: value) || Product.exists?(name: value))
  end
end