class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable, :confirmable, :lockable, :registerable, :recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

  validates :email,      presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :role,       presence: true
  validates :crm,        presence: true
  validates :phone,      presence: true

  has_many :user_clients
  has_many :clients, through: :user_clients
  has_many :estimates

  audited

  def to_s
    full_name
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  def admin?
    role == UserRole::ADMIN
  end

  def link
    Rails.application.routes.url_helpers.edit_user_path(self)
  end
end
