class DishlistsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    @dishlists = @user.dishlists.all
  end

  def show
  end

  def create
    @dishlist = Dishlist.new(dishlist_params)
    @dishlist.user = current_user
    if @dishlist.save
      redirect_to dishlist_path(@dishlist.id)
    else
      render :index
    end
  end

  def update
  end

  def destroy
  end

  private

  def set_user
    @user = current_user
  end

  def set_dishlist
    @dishlist = Dishlist.find(params[:id])
  end

  def dishlist_params
    params.require(:dishlist).permit(:name)
  end
end
