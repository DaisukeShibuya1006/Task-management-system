class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password

  validates :name, presence: true, length: { maximum: 15 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 8 }
end
