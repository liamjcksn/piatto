class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def discover
    session[:postcode] = params[:query]
    redirect_to restaurants_path
  end
end
