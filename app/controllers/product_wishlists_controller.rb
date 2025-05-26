class ProductWishlistsController < ApplicationController
  before_action :set_product_wishlist, only: %i[show destroy]
  before_action :set_current_user
  before_action :authorize_user

  # GET /product_wishlists
  def index
    @product_wishlists = ProductWishlist.all
    render json: @product_wishlists
  end

  def show
    render json: @producyt_wishlist

  end

  # POST /product_wishlists
  def create
    @product_wishlist = @current_user.product_wishlists.new(product_wishlist_params)

    if @product_wishlist.save
      render json: @product_wishlist, status: :created
    else
      render json: @product_wishlist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_wishlists/:id
  def destroy
    @product_wishlist.destroy
    head :no_content
  end

  # GET /my_wishlist
  def my_wishlist
    @favourites = @current_user.product_wishlists.includes(product: :images)
    render json: @favourites.to_json(
      include: {
        product: {
          include: :images
        }
      }
    )
  end
  

  private

  def product_wishlist_params
    params.require(:product_wishlist).permit(:product_id)
  end

 
  def set_product_wishlist
    @product_wishlist = ProductWishlist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Wishlist item not found' }, status: :not_found
  end
  
end
