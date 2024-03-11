class Api::V1::CafesController < ApplicationController
  def index
    if params[:title].present?
      @cafes = Cafe.where('title ILIKE ?', "%#{params[:title]}%")
    else
      @cafes = Cafe.all
    end
    # Putting the most recently created cafes first
    render json: @cafes.order(created_at: :desc)
  end

  def create
    @cafe = Cafe.new(cafe_params)
    if @cafe.save
      render json: @cafe, status: :created
    else
      render json: { error: @cafe.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def cafe_params
    # {
    #   "cafe": {
    #     "title": "Le Wagon Tokyo",
    #     "address": "2-11-3 Meguro, Meguro City, Tokyo 153-0063",
    #     "picture": "https://www-img.lewagon.com/wtXjAOJx9hLKEFC89PRyR9mSCnBOoLcerKkhWp-2OTE/rs:fill:640:800/plain/s3://wagon-www/x385htxbnf0kam1yoso5y2rqlxuo",
    #     "criteria": ["Stable Wi-Fi", "Power sockets", "Coffee", "Food"],
    #     "hours": {
    #       "Mon": ["10:30 – 18:00"],
    #       "Tue": ["10:30 – 18:00"],
    #       "Wed": ["10:30 – 18:00"],
    #       "Thu": ["10:30 – 18:00"],
    #       "Fri": ["10:30 – 18:00"],
    #       "Sat": ["10:30 – 18:00"]
    #     }
    #   }
    # }
    params.require(:cafe).permit(:title, :address, :picture, hours: {}, criteria: [])
  end
end
