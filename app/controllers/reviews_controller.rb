class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show update destroy ]
  before_action :set_current_user

  # 🔐 Admin-only actions
  before_action :authorize_admin, only: %i[ show update destroy ]

  # 🔐 Users (and admins) can create reviews
  before_action :authorize_user_or_admin, only: %i[ create ]

  # 🔐 Only users can access their own reviews (admins don't need this)
  before_action :authorize_user, only: %i[ user_reviews ]

  # GET /reviews — Admins only
  def index
    @reviews = Review.all
    render json: @reviews
  end

  # GET /reviews/:id — Admins only
  def show
    render json: @review
  end

  # POST /reviews — Users and admins
  def create
    @review = @current_user.reviews.build(review_params.except(:user_id))

    if @review.save
      ReviewMailer.new_review(@review).deliver_now
      render json: @review, status: :created, location: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/:id — Admins only
  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/:id — Admins only
  def destroy
    @review.destroy!
  end

  # GET /user_reviews — Users only
  def user_reviews
    @reviews = @current_user.reviews
    render json: @reviews
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:name, :header, :text, :rating, :platform, :reviewed, :product_id)
  end

  # 🔐 Allows both users and admins

end
