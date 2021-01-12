class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password

  validates :name, presence: true, length: { maximum: 15 }
  validates :email, presence: true
  validates :password_digest, presence: true, length: { minimum: 8 }
end
