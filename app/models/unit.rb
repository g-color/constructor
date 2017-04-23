class Unit < ApplicationRecord
  acts_as_paranoid
  audited

  validates :name, presence: true

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.units_path
  end
end
