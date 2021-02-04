3.times do |n|
  restaurant = Restaurant.new(
    name: "testレストラン_#{n}",
    fee: 100,
    time_required: 10
  )

  12.times do |m|
    # 他のモデルと関連付けてインスタンスを作る場合buildを使う
    restaurant.foods.build(
      name: "フード名_#{m}",
      price: 500,
      description: "フード_#{m}の説明文です。"
    )
  end

  # save => 失敗時にfalseを返す
  # save! => 失敗時に例外を返す
  restaurant.save!
end