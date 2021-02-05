# --- ここから追加 ---
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create]

      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exsits?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
            # 406 Not Acceptableを返す
          },  status: :not_acceptable
        end
      end
      


      private
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end
      
    end
  end
end