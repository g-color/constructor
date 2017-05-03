class ClientFile < ApplicationRecord

  belongs_to :estimate
  belongs_to :asset_file

end
