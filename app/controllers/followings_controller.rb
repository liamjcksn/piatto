class FollowingsController < ApplicationController
  def create
    @user = User.find(params[:id])
    @user.followees << current_user
    @user.save
    flash[:notice] = "followed"
    redirect_back(fallback_location: root_path)
    # current_user.followees << @user
    # current_user.save!
  end

  def destroy
    @user = User.find(params[:id])
    @user.followed_users.find_by(followee_id: current_user).destroy
    @user.save
    flash[:notice] = "unfollowed"
    redirect_back(fallback_location: root_path)
  end
  
  # def follow
  # @user = User.find(params[:id])
  # current_user.followees << @user
  # current_user.save!
  # end

  # def unfollow
  # @user = User.find(params[:id])
  # current_user.followed_users.find_by(followee_id: @user.id).destroy
  # current_user.save
  # redirect_to search_path(@query)
  # end
end
