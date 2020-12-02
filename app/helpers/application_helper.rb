module ApplicationHelper
  include Pagy::Frontend

  def avatar_tag(params = nil)
    params[:width] = 50 unless params[:width]
    params[:height] = 50 unless params[:height]
    params[:crop] = :fill unless params[:crop]
    if params[:user]
      if params[:user].avatar.attached?
        cl_image_tag(params[:user].avatar.key, params.except(:user))
      else
        image_tag("default-user-image.png", params.except(:user))
      end
    elsif current_user.avatar.attached?
      cl_image_tag(current_user.avatar.key, params)
    else
      image_tag("default-user-image.png", params)
    end
  end

  def local_restaurants_array
    local_string = ""
    only_ids = cookies.select do |cookie, _|
      cookie.start_with?("local_restaurants_")
    end
    only_ids.each { |_, value| local_string += "#{value}&" }
    local_string.split('&').map(&:to_i)
  end
end
