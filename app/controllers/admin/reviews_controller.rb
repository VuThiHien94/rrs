class Admin::ReviewsController < ApplicationController
  before_action :logged_as_admin
  before_action :load_book, :load_review, only: [:destroy]
  after_action :calculate_score, only: :destroy
  def destroy
    if @review && @review.destroy
      flash[:success] = t "controllers.flash.common.destroy_success",
        objects: t("activerecord.model.review")
    else
      flash[:danger] = t "controllers.flash.common.destroy_error",
        objects: t("activerecord.model.review")
    end
    redirect_to admin_restaurant_path @book
  end

  private
  def load_book
    @book = Book.find_by id: params[:restaurant_id]
  end

  def load_review
    @review = Review.find_by id: params[:id]
  end

  def calculate_score
    sum_rating = 0
    sum_rating_place = 0
    sum_rating_service = 0
    sum_rating_food = 0
    sum_rating_price = 0
    count = @book.reviews.count
    @book.reviews.reduce(0)  do |sum, element|
      sum_rating = sum_rating + element.rating
      sum_rating_place = sum_rating_place + element.rating_place
      sum_rating_service = sum_rating_service + element.rating_service
      sum_rating_food = sum_rating_food + element.rating_food
      sum_rating_price = sum_rating_price + element.rating_price
    end
    if count == 0
      @book.update_attributes rate_score: 0,
        rate_place: 0, rate_service: 0,
        rate_food: 0, rate_price: 0
    else
      @book.update_attributes rate_score: sum_rating/count,
        rate_place: sum_rating_place/count, rate_service: sum_rating_service/count,
        rate_food: sum_rating_food/count, rate_price: sum_rating_price/count
    end
  end
end
