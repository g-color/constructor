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

  scope :by_floor,    -> (floor)      { where('floors = ?', floor) }
  scope :only_signed, ->              { where('signed') }
  scope :date_start,  -> (date_start) { where('signing_date >= ?', date_start) if date_start.present? }
  scope :date_end,    -> (date_end)   { where('signing_date <= ?', date_end) if date_end.present? }
  scope :area_start,  -> (area_start) { where('area >= ?', area_start) if area_start.present? }
  scope :area_end,    -> (area_end)   { where('area < ?', area_end) if area_end.present? }

  validates :name,               presence: true
  validates :price,              presence: true
  validates :area,               presence: true
  validates :first_floor_height, presence: true

  validates :client, presence: true

  has_many :client_files
  accepts_nested_attributes_for :client_files, reject_if: :all_blank, allow_destroy: true

  has_many :technical_files
  accepts_nested_attributes_for :technical_files, reject_if: :all_blank, allow_destroy: true

  def calc_parameters
    self.price_by_area = (self.price / self.area).round 2 if self.area > 0
    self.price_by_stage_aggregated[0] = price_by_stage[0]
    self.price_by_stage_aggregated[1] = price_by_stage_aggregated[0] + price_by_stage[1]
    self.price_by_stage_aggregated[1] = price_by_stage_aggregated[1] + price_by_stage[2]
    (0..2).each do |i|
      self.price_by_area_per_stage[i] = (self.price_by_stage_aggregated[i] / self.area).round 2 if self.area > 0
      self.discount_amount[i] = (self.price_by_stage[i] * self.discount_by_stages[i] / 100.0).round 2
      self.price_by_stage_aggregated_discounted[i] = self.price_by_stage_aggregated[i] - self.discount_amount[i]
      self.price_by_area_per_stage_discounted[i] = (self.price_by_stage_aggregated_discounted[i] / area).round 2
    end
    self.floors = self.get_floor
    self.save
  end

  def get_floor
    return 3 if third_floor_height_min > 0 && third_floor_height_min > 1800
    return 2.5 if third_floor_height_min > 0 && third_floor_height_min < 1800
    return 2 if second_floor_height_min > 0 && second_floor_height_min > 1800
    return 1.5 if second_floor_height_min > 0 && third_floor_height_min < 1800
    1
  end
end
