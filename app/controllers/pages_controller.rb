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
end
