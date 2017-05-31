class Product < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :unit
  belongs_to :category

  scope :filter_name, -> (name)        { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :category,    -> (category_id) { where(category_id: category_id) if category_id.present? }

  validates :name,        unique_name: true, presence: true, length: { in: 2..256 }
  validates :description, length: { in: 2..1024 }
  validates :hint,        length: { in: 2..5102412 }
  validates :unit_id,     presence: true
  validates :category_id, presence: true
  validates :profit,      presence: true
  validates :stage,       presence: true
  validates :product_compositions, product_items: true


  has_and_belongs_to_many :items,
              class_name: "Product",
              join_table: :product_compositions,
              foreign_key: :product_id,
              association_foreign_key: :constructor_object_id

  has_many :product_compositions
  has_many :product_template_sets
  has_many :product_templates, through: :product_template_sets
  has_many :product_sets,      through: :product_template_sets

  def self.map_for_estimate
    all.map do |x|
      {
        id:                 x.id,
        name:               x.name,
        unit:               x.unit.name,
        custom:             x.custom,
        hint:               x.hint,
        sets:               x.get_sets,
        profit:             x.profit,
        price_with_work:    x.price,
        price_without_work: x.price_without_work
      }
    end
  end

  def save_compositions(compositions)
    ids = compositions.map { |c| c['id'] }
    product_compositions.where.not(id: ids).destroy_all
    compositions.each do |c|
      composition = product_compositions.find_or_initialize_by(constructor_object_id: c['id'])
      composition.update(value: c['quantity'])
    end
  end

  def get_compositions
    return [] if custom

    self.product_compositions.includes(:constructor_object).map do |x|
      {
        id:       x.constructor_object.id,
        name:     x.constructor_object.name,
        unit:     x.constructor_object.unit.name,
        quantity: x.value
      }
    end
  end

  def save_sets(sets)
    updated_ids = []
    sets.each do |s|
      if s['id'] < 1492000000000
        set = ProductSet.find(s['id'])
      else
        set = ProductSet.find_or_initialize_by(name: s['name'])
      end
      set.update(name: s['name'])

      s['items'].each do |t|
        if t['id'] < 1492000000000
          template = ProductTemplate.find(t['id'])
        else
          template = ProductTemplate.find_or_initialize_by(name: t['name'])
        end
        template.update(name: t['name'])

        id = t['value']['id']
        value = product_template_sets.find_or_initialize_by(product_template: template, product_set: set)
        id = ConstructorObject.find_by(name: t['value']['name']).id if id.blank?
        value.update(constructor_object_id: id)
        updated_ids.push(value.id)
      end
    end
    self.product_template_sets.where.not(id: updated_ids).destroy_all
  end


  def get_templates
    return [] unless custom

    self.product_templates.distinct.map do |x|
      {
        id:   x.id,
        name: x.name
      }
    end
  end

  def get_sets
    return [] unless custom

    self.product_sets.includes(
      :product_template_sets,
      product_template_sets: [:product_template, :constructor_object, constructor_object: [:unit]]
    ).distinct.map do |x|
      {
        id: x.id,
        name: x.name,
        items: x.product_template_sets.where(product: self).map do |y|
          {
            id: y.product_template.id,
            name: y.product_template.name,
            value: {
              id:   y.constructor_object.id,
              name: y.constructor_object.name,
              unit: y.constructor_object.unit.name,
              price: y.constructor_object.price,
              work_primitive: y.constructor_object.work_primitive?
            }
          }
        end
      }
    end
  end

  def price
    price = 0
    unless custom
      product_compositions.includes(:constructor_object).each do |composition|
        child  = composition.constructor_object
        price += child.price * composition.value unless child.price.blank?
      end
    end
    price
  end

  def price_without_work
    price = 0
    unless custom
      product_compositions.includes(:constructor_object).each do |composition|
        child  = composition.constructor_object
        price += child.price * composition.value unless child.price.blank? || child.work_primitive?
      end
    end
    price
  end

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.edit_product_path(self)
  end

  def update_report_primitivies(estimate, quantity)
    self.product_compositions.each do |product_composition|
      product_composition.update_report_primitivies(estimate, quantity)
    end
  end

  def get_primitives(undivisibilty_objects: false)
    result = {}
    self.product_compositions.each do |product_composition|
      primitives = product_composition.get_primitives(undivisibilty_objects: undivisibilty_objects)
      primitives.each do |key, value|
        result[key] = 0 if result[key].nil?
        result[key] += value
      end
    end
    result
  end
end
