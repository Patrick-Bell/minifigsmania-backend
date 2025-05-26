class PromotionsController < ApplicationController
  before_action :set_promotion, only: %i[ show update destroy ]
  before_action :authorize_admin, except: [:index, :show]

  Stripe.api_key = ENV['STRIPE_API_KEY']


  # GET /promotions
  def index
    @promotions = Promotion.all

    render json: @promotions
  end

  # GET /promotions/1
  def show
    render json: @promotion
  end

  # POST /promotions
  def create
    @promotion = Promotion.new(promotion_params)
  
    if @promotion.percent_off.present? && @promotion.percent_off > 0
      Stripe::Coupon.create({
        id: @promotion.code,
        percent_off: @promotion.percent_off,
        duration: 'forever',
      })
    end

    if @promotion.amount_off.present? && @promotion.amount_off > 0
      Stripe::Coupon.create({
        id: @promotion.code,
        amount_off: (@promotion.amount_off.to_f * 100).to_i,
        duration: 'forever',
        currency: 'gbp'
    })
  end
  
    if @promotion.save
      render json: @promotion, status: :created, location: @promotion
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end
  
  

  # PATCH/PUT /promotions/1
  def update
    if @promotion.update(promotion_params)
      render json: @promotion
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /promotions/1
  def destroy
    @promotion.destroy!
    Stripe::Coupon.delete(@promotion.code)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def promotion_params
      params.require(:promotion).permit(:code, :percent_off, :duration, :coupon_id, :expires_at, :active, :usage_limit, :redeemed_count, :title, :description, :highlighted, :amount_off, :minimum_spend)
    end
end
