class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  # scopeはモデルそのものや関連するオブジェクトに対するクエリを指定することができる　返り値は必ずActiveRecord_Relationとなる
  # 全てのLineFoodからactive: trueなものの一覧をActiveRecord_Relationの形で返す
  # LineFood.active.allのように使う
  scope :active, -> { where(active: true) }
  
  # 他の店舗のレストランidが合った場合、ActiveRecord_Relationが返る
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }

  def total_amount
    food.price * count
  end　
end