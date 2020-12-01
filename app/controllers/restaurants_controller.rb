require 'json'
require 'net/http' # or open-uri but not secure
require 'nokogiri'


class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.find(params[:id])
    @dish = @restaurant.dishes
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
      new_dishes = []
      JSON.parse(json_menu)["items"].each do |dish|
        if dish["name"] && Dish.find_by(just_eat_dish_id: dish["id"].to_i).nil?
          new_dishes << { just_eat_dish_id: dish["id"].to_i,
                          name: dish["name"],
                          description: dish["description"],
                          restaurant_id: restaurant.id }
        end
      end

      dishes_with_prices = return_objects_with_price(restaurant, new_dishes)
      dishes_with_prices.each { |dish| Dish.create(dish) }

      redirect_to restaurant_path(Restaurant.find_by(just_eat_id: restaurant_params[:just_eat_id]).id)
    else
      restaurant = Restaurant.create(restaurant_params)


       just_eat_id = URI.encode(restaurant_params[:just_eat_id])
       url = "https://uk.api.just-eat.io/restaurants/uk/#{just_eat_id}/catalogue/items?limit=500"
       json_menu = Net::HTTP.get(URI(url))
       new_dishes = []
       JSON.parse(json_menu)["items"].each do |dish|
         new_dishes << { just_eat_dish_id: dish["id"].to_i, name: dish["name"], description: dish["description"], restaurant_id: restaurant.id, average_rating: 0.0, reviews_count: 0 } if dish["name"]
      end

      dishes_with_prices = return_objects_with_price(restaurant, new_dishes)
      dishes_with_prices.each { |dish| Dish.create(dish) }

      redirect_to restaurant_path(restaurant.id)
    end
  end

  private

  def restaurant_params
    params.permit(:name, :just_eat_id, :latitude, :longitude, :url, :logourl, :postcode)
  end

  def return_objects_with_price(restaurant, menu_items)
    menu_item_names = menu_items.map { |menu_item| menu_item[:name] }

    # Scraping:
    restaurant_url = restaurant.url
    url = "#{restaurant_url}/menu"
    html_file = Net::HTTP.get(URI(url))
    html_doc = Nokogiri::HTML(html_file)
    item_class = '.c-menuItems-content'
    search_results = html_doc.search(item_class)
    return false if search_results.empty?

    search_results.each do |element|
      heading = element.search('.c-menuItems-heading')
      price = element.search('.c-menuItems-price')
      if heading.first && price.first && menu_item_names.include?(heading.first.text.strip)
        item = menu_items.select { |menu_item| menu_item[:name] == heading.first.text.strip }.first
        item[:price] = price.first.text.strip.gsub('£', '').to_f * 100
      end
    end

    return menu_items.reject { |menu_item| menu_item[:price].nil? || menu_item[:price].zero? }.uniq
  end
end
