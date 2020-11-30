class DishlistsController < ApplicationController
  before_action :set_user, only: [:index, :create ]
  before_action :set_dishlist, only: [:show, :update, :destroy]

  def index
    @dishlists = @user.dishlists
    @dishlist = Dishlist.new
  end

  def show
    @dishlist_dishes = @dishlist.dishlist_dishes
    @dishes = @dishlist.dishes
  end

  def create
    @dishlist = Dishlist.new(dishlist_params)
    @dishlist.user = current_user
    if @dishlist.save
      flash[:success] = "Dishlist successfully created"
      redirect_to user_dishlists_path(params[:user_id])
    else
      flash[:error] = "Something went wrong"
      render :index
    end
  end

  def update
  end

  def destroy
    @dishlist.destroy
    redirect_to user_dishlists_path(current_user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_dishlist
    @dishlist = Dishlist.find(params[:id])
  end

  def dishlist_params
    params.require(:dishlist).permit(:name, :photo)
  end
end
