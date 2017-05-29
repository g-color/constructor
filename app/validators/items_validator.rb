class ItemsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ids = value.map(&:children_id)
    record.errors[:base] << "Должно быть не менее одного примитива или объекта" if value.blank?
    record.errors[:base] << "Среди объектов и примитивов обнаружены дубликаты" if (ids.detect{ |e| ids.count(e) > 1 }).present?
  end
end