class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.find(params[:id])
    @dish = @restaurant.dishes
  end
end
