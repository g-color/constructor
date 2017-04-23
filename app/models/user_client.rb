class UserClient < ApplicationRecord
  belongs_to :client
  belongs_to :user

  scope :owner,     -> (user) { where("user_id = ? and owner = true", user.id) }
  scope :delegated, -> (user) { where("user_id = ? and owner = false", user.id) }
end
