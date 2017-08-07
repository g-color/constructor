class UserClient < ApplicationRecord
  belongs_to :client
  belongs_to :user

  scope :owner,     -> (user) { joins(:client).where("user_id = ? and owner = true", user.id).merge(Client.where(archived: false)) }
  scope :delegated, -> (user) { joins(:client).where("user_id = ? and owner = false", user.id).merge(Client.where(archived: false)) }
  scope :archived,  -> (user) { joins(:client).where("user_id = ?", user.id).merge(Client.where(archived: true)) }
end
