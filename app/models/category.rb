class Category < ApplicationRecord
  acts_as_paranoid
  audited

  validates :name, presence: true, length: { in: 2..256 }

  def to_s
    name
  end

  def link
    Rails.application.routes.url_helpers.categories_path
  end
end
