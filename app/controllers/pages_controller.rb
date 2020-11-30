require 'json'
require 'net/http'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :postcode]

  def home
  end

  def discover
    @people_you_follow = current_user.followees
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
      @people = User.search_by_username_or_name(@query)
      @dishes = Dish.search_by_dish(@query)

      if /^([a-zA-Z]{0,2})([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9])([ ]*)([0-9]{1,2})([a-zA-z][a-zA-z])$/.match?(params[:postcode])
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
    if /^([a-zA-Z]{0,2})([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9])([ ]*)([0-9]{1,2})([a-zA-z][a-zA-z])$/.match?(params[:postcode])
      postcode = URI.encode(params[:postcode])
      url = "https://uk.api.just-eat.io/restaurants/bypostcode/#{postcode}"
      json_restaurants = Net::HTTP.get(URI(url))
      all_restaurants = JSON.parse(json_restaurants)["Restaurants"].map do |restaurant|
        restaurant["Id"]
      end
      cookies.each do |cookie, value|
        cookies.delete(cookie) if cookie.to_s.start_with?("local_restaurants")
      end
      all_restaurants.each_slice(300).with_index { |arr, i| cookies["local_restaurants_#{i}".to_sym] = arr }
      redirect_to discover_path
    else
      redirect_to(root_path) and return
    end
  end
end
