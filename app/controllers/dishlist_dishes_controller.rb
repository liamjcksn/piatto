class DishlistDishesController < ApplicationController
  def create
  end

  def destroy
    @dishlist_dish = DishlistDish.find(params[:id])
    @dishlist_dish.destroy
  end

  private

  def set_dishlist
  end
end
