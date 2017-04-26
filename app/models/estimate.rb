class Estimate < ApplicationRecord
  acts_as_paranoid
  audited

  FLOOR_NAME = {
    '1':   'Одноэтажный',
    '1.5': 'Одноэтажный с мансардой',
    '2':   'Двухэтажный',
    '2.5': 'Двухэтажный с мансардой',
    '3':   'Трехэтажный'
  }

  AREA_MIN = 10
  AREA_MAX = 250
  AREA_STEP = 20

  belongs_to :client
  belongs_to :user
  has_many :client_files
  has_many :stages

  scope :by_floor,    -> (floor)      { where('floors = ?', floor) }
  scope :only_signed, ->              { where('signed') }
  scope :date_start,  -> (date_start) { where('signing_date >= ?', date_start - 1.day) if date_start.present? }
  scope :date_end,    -> (date_end)   { where('signing_date <= ?', date_end + 1.day) if date_end.present? }
  scope :area_start,  -> (area_start) { where('area >= ?', area_start) if area_start.present? }
  scope :area_end,    -> (area_end)   { where('area < ?', area_end) if area_end.present? }

  validates :name,               presence: true
  validates :price,              presence: true
  validates :area,               presence: true
  validates :first_floor_height, presence: true

  validates :client, presence: true

  accepts_nested_attributes_for :client_files, reject_if: :all_blank, allow_destroy: true

  has_many :technical_files
  accepts_nested_attributes_for :technical_files, reject_if: :all_blank, allow_destroy: true

  def calc_parameters
    self.price_by_area = (self.price / self.area).round 2 if self.area > 0
    self.price_by_stage_aggregated[0] = price_by_stage[0]
    self.price_by_stage_aggregated[1] = price_by_stage_aggregated[0] + price_by_stage[1]
    self.price_by_stage_aggregated[2] = price_by_stage_aggregated[1] + price_by_stage[2]
    (0..2).each do |i|
      self.price_by_area_per_stage[i] = (self.price_by_stage_aggregated[i] / self.area).round 2 if self.area > 0
      self.discount_amount[i] = (self.price_by_stage[i] * self.discount_by_stages[i] / 100.0).round 2
      self.price_by_stage_aggregated_discounted[i] = self.price_by_stage_aggregated[i] - self.discount_amount[i]
      self.price_by_area_per_stage_discounted[i] = (self.price_by_stage_aggregated_discounted[i] / area).round 2
    end
    self.floors = self.get_floor
    self.save
  end

  def update_json_values(json_stages)
    json_stages = JSON.parse(json_stages)
    self.price_by_stage = [json_stages[0]['price'], json_stages[1]['price'], json_stages[2]['price']]
    json_stages.each do |s|
      # Добавляем или обновляем этапы
      stage = self.stages.find_or_initialize_by(number: s['number'])
      stage.update(
        number:      s['number'],
        price:       s['price'],
        total_price: s['total_price'].round(2),
      )
      # Удаляем продукты которые не пришли
      product_ids = s['products'].map { |p| p['id'] }
      stage.stage_products.where.not(product_id: product_ids).destroy_all
      # Добавляем или обновляем продукты которые пришли
      s['products'].each do |p|
        product = stage.stage_products.find_or_initialize_by(product_id: p['id'])
        product.update(
          quantity:   p['quantity'],
          price:      p['price'].present? ? p['price'] : 0,
        )
        if p['custom']
          # Удаляем сеты которые не пришли
          set_ids = p['sets'].map { |s| s['id']}
          product.stage_product_sets.where.not(product_set_id: set_ids)
          # Добавляем или обновляем сеты которые пришли
          p['sets'].each do |stage_set|
            set = product.stage_product_sets.find_or_initialize_by(product_set_id: stage_set['id'])
            set.update(selected: stage_set['selected'])
            # Удаляем все значения для сета которые не пришли
            item_ids = stage_set['items'].map { |i| i['id']}
            set.stage_product_set_values.where.not(product_template_id: item_ids).destroy_all
            # Добавляем или обновляем значения для сета
            stage_set['items'].each do |i|
              value = set.stage_product_set_values.find_or_initialize_by(product_template_id: i['id'])
              value.update(
                constructor_object_id: i['value']['id'],
                quantity:              i['quantity']
              )
            end
          end
        end
      end
    end
    self.calc_parameters
  end

  def get_stages
    if self.new_record?
      [
        {
          number: 1,
          text: get_stage_text(1),
          products: [],
          price: 0,
          total_price: 0,
        },
        {
          number: 2,
          text: get_stage_text(2),
          products: [],
          price: 0,
          total_price: 0,
        },
        {
          number: 3,
          text: get_stage_text(3),
          products: [],
          price: 0,
          total_price: 0,
        }
      ]
    else
      stages.includes(:stage_products).map do |stage|
        {
          number:      stage.number,
          text:        get_stage_text(stage.number),
          price:       stage.price,
          total_price: stage.total_price,
          products:    stage.stage_products.includes(:stage_product_sets, :product, product: [:unit] ).map do |stage_product|
            {
              id:       stage_product.product.id,
              name:     stage_product.product.name,
              unit:     stage_product.product.unit.name,
              custom:   stage_product.product.custom,
              price:    stage_product.price,
              quantity: stage_product.quantity,
              sets:     stage_product.product.custom ? get_stage_product_set(stage_product) : []
            }
          end
        }
      end
    end
  end

  def get_stage_product_set(stage_product)
    stage_product.stage_product_sets.includes(:stage_product_set_values).map do |product_set|
      {
        id:       product_set.product_set.id,
        name:     product_set.product_set.name,
        selected: product_set.selected,
        items: product_set.stage_product_set_values.includes(:product_template, :constructor_object, constructor_object: [:unit]).map do |item|
          {
            id:       item.product_template.id,
            name:     item.product_template.name,
            quantity: item.quantity,
            value: {
              id:     item.constructor_object.id,
              name:   item.constructor_object.name,
              unit:   item.constructor_object.unit.name,
              price:  item.constructor_object.price
            },
          }
        end
      }
    end
  end

  def get_stage_text(number)
    case number
    when 1
      {
        name:     'Первый этап',
        summ:     'Итого по первому этапу:',
        summ_dis: 'по первому этапу',
        discount: 'Итого по первому этапу со скидкой:'
      }
    when 2
      {
        name:     'Второй этап',
        summ:     'Итого по двум этапам:',
        summ_dis: 'по второму этапу',
        discount: 'Итого по первому этапу со скидкой:'
      }
    when 3
      {
        name:     'Третий этап',
        summ:     'Итого по трем этапам:',
        summ_dis: 'по третьему этапу',
        discount: 'Итого по первому этапу со скидкой:'
      }
    end
  end

  def get_floor
    return 3   if third_floor_height_min  > 0 && third_floor_height_min  > 1800
    return 2.5 if third_floor_height_min  > 0 && third_floor_height_min  < 1800
    return 2   if second_floor_height_min > 0 && second_floor_height_min > 1800
    return 1.5 if second_floor_height_min > 0 && third_floor_height_min  < 1800
    1
  end

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.edit_estimate_path(self)
  end

  def update_report_primitivies
    self.stages.each do |stage|
      stage.update_report_primitivies
    end
  end
end
