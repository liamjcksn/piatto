class DishesController < ApplicationController

  def index
    @dishes = Diish.all
  end

  def new
    @dish = Dish.new
  end

  def show
    @dish = Dish.find(params[:id])
  end

  def create
    @dish = Dish.new(params[:dish])
    if @dish.save
      flash[:success] = "Dish successfully created"
      redirect_to @dish
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def update
    @dish = Dish.find(params[:id])
      if @dish.update_attributes(params[:dish])
        flash[:success] = "Dish was successfully updated"
        redirect_to @dish
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy
    redirect_to dashboard_path
  end

  private

  def dish_params
    params.require(:dish).permit(:name)
  end

end
