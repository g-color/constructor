class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable, :confirmable, :lockable, :registerable, :recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

  scope :engineers, -> { where(role: [Enums::User::Role::ENGINEER, Enums::User::Role::ADMIN]) }

  validates :email,      presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :role,       presence: true
  validates :crm,        presence: true, uniqueness: true, length: { minimum: 7, maximum: 7}
  validates :phone,      presence: true, numericality: { only_integer: true }

  has_many :user_clients
  # has_many :clients, through: :user_clients
  has_many :estimates

  acts_as_paranoid

  def to_s
    full_name
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  def admin?
    role == Enums::User::Role::ADMIN
  end

  def link
    Rails.application.routes.url_helpers.edit_user_path(self)
  end

  def clients
    if admin?
      Client.all
    else
      Client.where(id: UserClient.where(user_id: id).pluck(:client_id))
    end
  end
end
