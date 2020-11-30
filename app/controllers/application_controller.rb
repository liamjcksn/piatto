class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :go_to_home

  def go_to_home
    has_restaurants = false
    cookies.each do |cookie, _|
      has_restaurants = true if cookie.to_s.start_with?("local_restaurants")
    end
    redirect_to root_path unless has_restaurants
  end

  def after_sign_in_path_for(resource)
    discover_path
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :avatar])
  end
end
