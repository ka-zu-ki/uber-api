# --- ここから追加 ---
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create, replace]

      def create
        # 仮注文作成時に他店舗の商品がある場合
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exsits?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
            # 406 Not Acceptableを返す
          },  status: :not_acceptable
        end

        # 仮注文にfoodを追加
        set_line_food(@ordered_food)

        # if @line_food.save
        #   render json: {
        #     line_food: @line_food
        #   }, status: :created
        # else
        #   render json: {}, status: :internal_server_error
        # end

        line_food_save?(@line_food)
      end

      def index
        # active => モデルのscopeで定義したActiveRelationが返ってくる
        line_foods = LineFood.active.all
        if line_foods.exists?
          render json: {
            line_food_ids: line_foods.map { |line_food| line_food.id }
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum { |line_food| line_food[:count] }
            # total_amount => モデルで定義
            amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
        else
          # リクエストは成功したが空データとして204を返す
          render json: {}, status: :no_content
        end
      end

      def replace
        LineFood.active.other_restaurant(ordered_food.restaurent.id).each do |line_food|
          # 現在のline_foodsを非活性にする
          line_food.update_attributes!(:active, false)
        end
      end

      set_line_food(@ordered_food)

      # if @line_food.save
      #   render json: {
      #     line_food: @line_food
      #   }, status: :created
      # else
      #   render json: {}, status: :internal_server_error
      # end

      line_food_save?(@line_food)
      
      private
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      # 仮注文似商品のインスタンスを新規作成/追加
      def set_line_food(ordered_food)
        # 仮注文に商品が存在してたら商品を追加
        if ordered_food.line_food.prssent?
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end

      def line_food_save?(line_food)
        if line_food.save
          render json: {
            line_food: line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end
    end
  end
end