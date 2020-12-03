class DishlistDishesController < ApplicationController
  def create
    @dishlist_dish = DishlistDish.create(strong_params)
    if @dishlist_dish.save
      
      flash[:notice] = "Dish saved to dishlist!"
      redirect_to search_path(anchor: "dish-#{@dishlist_dish.dish.id}", query: params[:query])
    else
      redirect_to search_path(anchor: "dish-#{@dishlist_dish.dish.id}", query: params[:query])
    end
  end

  def destroy
    @dishlist_dish = DishlistDish.find(params[:id])
    @dishlist_dish.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_dishlist
    @dishlist = Dishlist.find(params[:id])
  end

  def strong_params
    params.require(:dishlist_dish).permit(:dishlist_id, :dish_id)
  end
end
