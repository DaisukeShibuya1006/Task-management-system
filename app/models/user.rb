class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }
  validates :password_digest, length: { minimum: 8, maximum: 20 }

  has_secure_password
end
