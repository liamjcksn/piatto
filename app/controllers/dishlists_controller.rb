class DishlistsController < ApplicationController
  before_action :set_user, only: [:index, :create]
  def index
    @dishlists = @user.dishlists.all
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  def set_user
    @user = current_user
  end
end
