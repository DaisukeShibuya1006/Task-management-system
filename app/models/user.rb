class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 15 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }

  before_destroy :not_delete_admin_last

  has_many :tasks, dependent: :destroy

  private

  # 管理ユーザ削除の制限
  def not_delete_admin_last
    return unless is_admin?

    throw :abort if User.where(is_admin: true).size == 1
  end
end
