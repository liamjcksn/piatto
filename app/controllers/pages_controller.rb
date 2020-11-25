class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def discover
  @people_you_follow = current_user.followees
  session[:postcode] = params[:query]
  redirect_to discover_path
  end
end
