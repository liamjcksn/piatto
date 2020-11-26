class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @dish = Dish.find(params[:dish_id])
    @review.dish = @dish
    @review.user = current_user
    if @review.save!
      redirect_to dish_path(@dish.id, anchor: "review-#{@review.id}")
    else
      render :new
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.delete
    redirect_to dish_path(@review.dish.id)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

end