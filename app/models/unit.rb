class Unit < ApplicationRecord
  acts_as_paranoid

  validates :name, uniqueness: true, presence: true, length: { in: 2..256 }

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.units_path
  end
end
