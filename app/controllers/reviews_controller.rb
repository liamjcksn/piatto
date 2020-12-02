class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @dish = Dish.find(params[:dish_id])
    @review.dish = @dish
    @review.user = current_user
    if @review.save!
      @dish.average_rating = (@dish.average_rating * @dish.reviews_count + @review.rating) / (@dish.reviews_count + 1)
      @dish.reviews_count += 1
      @dish.save
      puts "review made. average rating: #{@dish.average_rating}"
      redirect_to dish_path(@dish.id, anchor: "review-#{@review.id}")
    else
      render :new
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @dish.average_rating = (@dish.average_rating * @dish.reviews_count - @review.rating) / (@dish.reviews_count - 1)
    @dish.reviews_count -= 1
    @dish.save
    @review.delete
    redirect_to dish_path(@review.dish.id)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

end
