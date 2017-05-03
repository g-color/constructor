class TechnicalFile < ApplicationRecord
  belongs_to :budget
  belongs_to :asset_file
end
