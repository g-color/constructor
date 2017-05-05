class Client < ApplicationRecord
  acts_as_paranoid
  audited

  validates :first_name, presence: true
  validates :crm, uniqueness: true, presence: true, length: { minimum: 7, maximum: 7 }

  has_many :users, through: :user_clients
  has_many :user_clients, dependent: :delete_all
  has_many :estimates,    dependent: :delete_all

  def to_s
    full_name
  end

  def full_name
    "#{last_name} #{first_name} #{middle_name}"
  end

  def assign_owner(user)
    user_client = UserClient.find_or_initialize_by(client_id: self.id, user_id: user.id)
    user_client.update( user_id: user.id, owner: true )
  end

  def share(users)
    share_users = JSON.parse(users)
    UserClient.where(client: self, owner: false).where.not(user_id: share_users).destroy_all
    share_users.each do |user|
      UserClient.create(client: self, user_id: user, owner: false) unless shared_to_user?(user)
    end
  end

  def shared_to_user?(user)
    UserClient.exists?(client: self, user_id: user)
  end

  def link
    Rails.application.routes.url_helpers.edit_client_path(self)
  end
end
