class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }
  validates :text, length: { maximum: 50 }

  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  enum status: {
    yet: 0,
    doing: 1,
    complete: 2
  }

  enum priority: {
    high: 0,
    middle: 1,
    low: 2
  }
end
