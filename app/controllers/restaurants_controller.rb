class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    # theoretically, anyone could pass in any kind of parameters to create a new restaurant by just making
    # a post request. but, there's no method allowing us to efficiently get a restaurant's info from just
    # its ID, so i think this is the least resource-intensive way to go about things. banking on the fact
    # that rails knows where the post request came from.
    if Restaurant.where(just_eat_id: restaurant_params[:just_eat_id])[0]
      restaurant = Restaurant.find_by(just_eat_id: restaurant_params[:just_eat_id])

      just_eat_id = URI.encode(restaurant_params[:just_eat_id])
      url = "https://uk.api.just-eat.io/restaurants/uk/#{just_eat_id}/catalogue/items?limit=500"
      json_menu = Net::HTTP.get(URI(url))
      JSON.parse(json_menu)["items"].each do |dish|
        if dish["name"]
          Dish.create(just_eat_dish_id: dish["id"].to_i, name: dish["name"], description: dish["description"], restaurant_id: restaurant.id) unless Dish.find_by(just_eat_dish_id: dish["id"].to_i)
        end
      end

      redirect_to restaurant_path(Restaurant.find_by(just_eat_id: restaurant_params[:just_eat_id]).id)
    else
      restaurant = Restaurant.create(restaurant_params)


       just_eat_id = URI.encode(restaurant_params[:just_eat_id])
       url = "https://uk.api.just-eat.io/restaurants/uk/#{just_eat_id}/catalogue/items?limit=500"
       json_menu = Net::HTTP.get(URI(url))
       JSON.parse(json_menu)["items"].each do |dish|
         Dish.create(just_eat_dish_id: dish["id"].to_i, name: dish["name"], description: dish["description"], restaurant_id: restaurant.id) if dish["name"]
       end
      redirect_to restaurant_path(restaurant.id)
    end
  end

  private

  def restaurant_params
    params.permit(:name, :just_eat_id, :latitude, :longitude, :url, :logourl, :postcode)
  end
end
