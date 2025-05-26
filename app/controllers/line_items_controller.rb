class LineItemsController < ApplicationController
    before_action :set_line_item, only: %i[show update destroy]
    before_action :set_current_user
    before_action :authorize_user_or_admin, only: %i[update index]
    before_action :authorize_user, only: %i[create]
    before_action :authorize_admin, only: %i[destroy]
  
    # GET /line_items
    def index
      # Fetch all line items, optionally you can add filters (e.g., by order_id)
      @line_items = LineItem.all
      render json: @line_items
    end
  
    # GET /line_items/1
    def show
      render json: @line_item
    end
  
    # POST /line_items
    def create
      # Create a new line item under a given order
      @line_item = LineItem.new(line_item_params)
  
      if @line_item.save
        render json: @line_item, status: :created
      else
        render json: @line_item.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /line_items/1
    def update
      # Update specific line item
      if @line_item.update(line_item_params)
        render json: @line_item
      else
        render json: @line_item.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /line_items/1
    def destroy
      @line_item.destroy
      head :no_content # Return no content after successful deletion
    end
  
    private
  
    # Set the line item based on the provided ID
    def set_line_item
      @line_item = LineItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Line item not found' }, status: :not_found
    end
  
    # Only allow a list of trusted parameters through for line item actions
    def line_item_params
      params.require(:line_item).permit(
        :order_id, :name, :price, :quantity, :image, :product_id, :reviewed
      )
    end
  end
  