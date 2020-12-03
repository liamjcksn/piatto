require 'json'
require 'net/http'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home postcode]
  skip_before_action :go_to_home, only: %i[home postcode]

  def home
  end

  def discover
    @people_you_follow = current_user.followers.sample(10) # .select { |user| user.avatar.attached? }.sample(10)
    followees_dishes = []
    current_user.followers.each do |user|
      user.dishlists.each do |dishlist|
        followees_dishes_without_users = dishlist.dishes.order(average_rating: :desc).first(3)
        followees_dishes << followees_dishes_without_users.map { |fdwu| [fdwu, user]}
      end
    end
    @people_you_follow_have_been_enjoying = followees_dishes.flatten(1).sample(10)
    num_of_dishes = 3
    sim_dishes = []
    recc_similar_dishes = []
    current_user.dishlists.each do |dishlist|
      dishlist.dishes.last(num_of_dishes).each do |dish|
        sim_dishes << dish
      end
    end
    sim_dishes.sample(num_of_dishes).each do |dish|
      sim_dishes_for_dish = dish.get_similar_dishes(num_of_dishes)
      sim_dishes_for_dish.each { |d|
        recc_similar_dishes << d } if sim_dishes_for_dish
    end
    @recc_similar_dishes = recc_similar_dishes.uniq
    if params[:postcode].present?
      session[:postcode] = params[:postcode]
    end
  end

  def profile
    @user = User.find(params[:id])
    @followers = @user.followers
    @followees = @user.followees
    @dishlists = @user.dishlists
  end

  def search
    if params[:query].present? && params[:query].length < 200
      @query = params[:query]
      @people = User.search_by_username_or_name(@query).sort_by { |a| a.avatar.attached? ? 0 : 1 }
      search_result = Dish.search_by_dish(@query).reorder(average_rating: :desc)
      @number_of_dishes = search_result.count
      @pagy, @dishes = pagy(search_result, items: 5)

      # after pagy has been initialized:
      respond_to do |format|
        format.html
        format.json do
          render json: { entries: render_to_string(partial: "shared/dishes", formats: [:html]), pagination: view_context.pagy_bootstrap_nav(@pagy) }
        end
      end
      if /^([a-zA-Z]{0,2})([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9])( *)([0-9]{1,2})([a-zA-z][a-zA-z])$/.match?(params[:postcode])
        postcode = URI.encode(params[:postcode])
        url = "https://uk.api.just-eat.io/restaurants/bypostcode/#{postcode}"
        json_restaurants = Net::HTTP.get(URI(url))
        local_restaurants = JSON.parse(json_restaurants)["Restaurants"].map do |restaurant|
          { id: restaurant["Id"], name: restaurant["Name"], latitude: restaurant["Address"]["Latitude"], longitude: restaurant["Address"]["Longitude"], postcode: restaurant["Address"]["Postcode"], url: restaurant["Url"], logourl: restaurant["LogoUrl"] }
        end
        @restaurant_names = local_restaurants.find_all do |restaurant|
          restaurant[:name] =~ /#{params[:restaurant]}/i
        end
        # redirect_to discover_path
      end
    else
      redirect_to discover_path
    end
  end

  def postcode
    if /^([a-zA-Z]{0,2})([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9])( *)([0-9]{1,2})([a-zA-z][a-zA-z])$/.match?(params[:postcode])
      postcode = URI.encode(params[:postcode])
      url = "https://uk.api.just-eat.io/restaurants/bypostcode/#{postcode}"
      json_restaurants = Net::HTTP.get(URI(url))
      all_restaurants = JSON.parse(json_restaurants)["Restaurants"].map do |restaurant|
        restaurant["Id"]
      end
      cookies.each do |cookie, _value|
        cookies.delete(cookie) if cookie.to_s.start_with?("local_restaurants")
      end
      all_restaurants.each_slice(300).with_index { |arr, i| cookies["local_restaurants_#{i}".to_sym] = arr }
      redirect_to discover_path
    else
      redirect_to(root_path) and return
    end
  end

  private

  def local_restaurants_array
    local_string = ""
    only_ids = cookies.select do |cookie, _|
      cookie.start_with?("local_restaurants_")
    end
    only_ids.each { |_, value| local_string += "#{value}&" }
    local_string.split('&').map(&:to_i)
  end
end
