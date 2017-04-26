class Product < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :unit
  belongs_to :category

  scope :filter_name, -> (name) { where("name ILIKE ?", "%#{name}%") if name.present? }

  validates :name,        presence: true
  validates :unit_id,     presence: true
  validates :category_id, presence: true
  validates :profit,      presence: true
  validates :stage,       presence: true

  has_many :product_compositions
  has_many :product_template_sets
  has_many :product_templates, through: :product_template_sets
  has_many :product_sets,      through: :product_template_sets

  def self.map_for_estimate
    all.map do |x|
      {
        id:     x.id,
        name:   x.name,
        unit:   x.unit.name,
        custom: x.custom,
        sets:   x.get_sets,
        price:  x.price,
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

    self.product_templates.map do |x|
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
            }
          }
        end
      }
    end
  end

  def price
    price = 0
    if custom
    else
      product_compositions.includes(:constructor_object).each do |composition|
        price += composition.constructor_object.price if composition.constructor_object.price.present?
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
end
