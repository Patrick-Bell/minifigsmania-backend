class OrdersController < ApplicationController
  before_action :set_current_user
  before_action :set_order, only: %i[ show update destroy ]
  before_action :authorize_admin, only: %i[ show update destroy index ]
  before_action :authorize_user, only: %i[ user_orders track_order ]
  before_action :authorize_user_or_admin, only: %i[ order_refund ]

  # GET /orders
  def index
    @orders = Order.includes(:line_items).all

    render json: @orders.to_json(include: :line_items)
  end

  # GET /orders/1
  def show
    order = Order.includes(:line_items).find(params[:id])
    render json: order.to_json(include: :line_items)
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if @order.save
      OrderMailer.new_order(@order).deliver_now
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy!
  end

  def user_orders
    @orders = @current_user.orders.includes(:line_items)
    render json: @orders.to_json(include: :line_items)
  end
  

  def track_order
    @order = Order.find_by(tracking_id: params[:tracking_id])
    if @order
      render json: @order.to_json(include: :line_items)
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end


  def order_refund
    @order = Order.find_by(id: params[:id])

    if @order
      @order.update(status: 'refunded')
      OrderMailer.order_refund(@order).deliver_now
      render json: { message: 'Order refunded successfully' }, status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end

  end



  def chatbot_order
    @order = Order.find_by(tracking_id: params[:tracking_id])
    if @order
      render json: @order.to_json(include: :line_items)
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.require(:id))
    end
    

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(
        :user_id, :total_price, :status, :date, :address, 
        :payment_method, :delivery_date, :paid, :shipping_fee, 
        :tracking_id, :order_id, :name, :email, :phone, :platform,
        line_items_attributes: [:id, :order_id, :name, :price, :quantity, :image, :product_id]
      )
    end
    
end
