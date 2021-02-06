class Order < ApplicationRecord
  has_many :line_foods
  has_one :restaurant, through: :line_food

  validates :total_price, numericality: { greater_than: 0 }

  def save_with_update_line_foods!(line_foods)
    ActiveRecord::Base.transaction do
      line_foods.each do |line_food|
        # line_foodのaxctiveとorder(= order_id)を更新　orderとすることでorder_nameなどが追加された場合も更新できる
        line_food.update_attributes!(active: false, order: self)
      end
      # self => Orderクラスのインスタンスオブジェクト（つまりOrder自身）　
      self.save!
    end
  end
end