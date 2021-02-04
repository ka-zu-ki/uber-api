class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods
  belongs_to :order, optional: true

  validates :name, :fee, :time_required, presence: true
  validates :name, length: { maximum: 30 }
  # 手数料が0以上　-100などのマイナスの値が入ってしまうことを防ぐ
  validates :fee, numericality: { greater_than: 0 }
end

