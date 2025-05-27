class OrderMailer < ApplicationMailer
  
  
  def new_order(order)
  @order = order
  @discount = @order.discount || 0.0
  product_ids = @order.line_items.pluck(:product_id)
  first_product = @order.line_items.first.product

  category_based_products = Product
    .where(category: first_product.category)
    .where.not(id: product_ids)
    .sample(3)

  fallback_products = Product
    .where.not(id: product_ids)
    .sample(3)

  selected_products = category_based_products.presence || fallback_products

  @recommended_products = selected_products.map do |product|
    {
      name: product.name,
      price: product.price,
      quantity: 1,
      image: product.images.first&.url || 'https://example.com/placeholder.jpg',
      id: product.id
    }
  end

  mail(to: @order.email, subject: "MinifigsMania | Order Confirmation")
end

  
    def new_order_admin(order)

      @order = order
      @user = User.find_by(id: @order.user_id)
      @discount = @order.discount || 0.0

      mail(to: ENV['EMAIL'], subject: "MinifigsMania | New Order")
    end


    def order_refund(order)
      @order = order
      @user = User.find_by(id: @order.user_id)

      mail(to: @order.email, subject: 'MinifigsMania | Order Refund')
    end
    

    def order_refund_admin(order)

      @order = order

      mail(to: ENV['EMAIL'], subject: 'MinifigsMania | Refund Request')
    end

  end
  