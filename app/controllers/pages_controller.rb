class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def discover
    @people_you_follow = current_user.followees
    if params[:query].present?
      session[:postcode] = params[:query]
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
    else
      redirect_to discover_path
    end
  end
end
