class CheckoutController < ApplicationController
  require 'stripe'

  before_action :set_current_user
  before_action :set_stripe_key

  def create_checkout_session
    cart = params[:cart] || []
    code = params[:code]

    Rails.logger.debug "Received cart: #{cart.inspect}"
    Rails.logger.debug "Received code: #{code.inspect}"
    Rails.logger.debug "Full params: #{params.inspect}"

    total_weight = cart.sum { |item| item["weight"] * item["quantity"] }  # weight in grams
    Rails.logger.debug "Total weight: #{total_weight}g"

    # Shipping options based on weight
    shipping_options = if total_weight < 100
      [
        {
          shipping_rate_data: {
            type: "fixed_amount",
            fixed_amount: { amount: 155, currency: "gbp" },
            display_name: "Royal Mail 2nd Class",
            delivery_estimate: {
              minimum: { unit: "business_day", value: 2 },
              maximum: { unit: "business_day", value: 3 }
            }
          }
        },
        {
          shipping_rate_data: {
            type: "fixed_amount",
            fixed_amount: { amount: 210, currency: "gbp" },
            display_name: "Royal Mail 2nd Class (Tracked)",
            delivery_estimate: {
              minimum: { unit: "business_day", value: 2 },
              maximum: { unit: "business_day", value: 3 }
            }
          }
        },
        {
          shipping_rate_data: {
            type: "fixed_amount",
            fixed_amount: { amount: 270, currency: "gbp" },
            display_name: "Royal Mail 1st Class",
            delivery_estimate: {
              minimum: { unit: "business_day", value: 1 },
              maximum: { unit: "business_day", value: 2 }
            }
          }
        }
      ]
    else
      [
        {
          shipping_rate_data: {
            type: "fixed_amount",
            fixed_amount: { amount: 210, currency: "gbp" },
            display_name: "Express (1-2 Days)",
            delivery_estimate: {
              minimum: { unit: "business_day", value: 1 },
              maximum: { unit: "business_day", value: 2 }
            }
          }
        }
      ]
    end

    line_items = cart.map do |item|
      images = item["images"].reject { |img| img["url"].blank? }

      {
        price_data: {
          currency: 'gbp',
          product_data: {
            name: item["name"],
            images: images.map { |img| img["url"] }
          },
          unit_amount: (item['price'] * 100).to_i,
        },
        quantity: item["quantity"]
      }
    end

    session_params = {
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      shipping_address_collection: {
        allowed_countries: ['GB']
      },
      metadata: {
        user_id: @current_user&.id
      },
      expand: ['line_items'],
      shipping_options: shipping_options,
      success_url: ENV['CHECKOUT_SUCCESS_URL'] || 'https://minifigsmania.netlify.app/success',
      cancel_url: ENV['CHECKOUT_CANCEL_URL'] || 'https://minifigsmania.netlify.app/cancel'
    }

    if code.present?
      begin
        coupon = Stripe::Coupon.retrieve(code)
        session_params[:discounts] = [{ coupon: coupon.id }]
      rescue Stripe::InvalidRequestError => e
        Rails.logger.warn "Coupon not found: #{e.message}"
      end
    end

    session = Stripe::Checkout::Session.create(session_params)

    render json: { url: session.url }
  end

  def stripe_webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    signing_secret = ENV['STRIPE_WEBHOOK_SECRET']
  
    event = verify_stripe_event(payload, sig_header, signing_secret)
    return head :bad_request unless event
  
    case event.type
    when 'checkout.session.completed'
      handle_checkout_session_completed(event.data.object)
    end
  
    head :ok
  end
  
  private
  
  def verify_stripe_event(payload, sig_header, signing_secret)
    Stripe::Webhook.construct_event(payload, sig_header, signing_secret)
  rescue JSON::ParserError => e
    Rails.logger.error("❌ Invalid JSON: #{e.message}")
    nil
  rescue Stripe::SignatureVerificationError => e
    Rails.logger.error("❌ Invalid Signature: #{e.message}")
    nil
  end
  
  def handle_checkout_session_completed(session)
    Rails.logger.info "▶️ Handling checkout.session.completed for session: #{session.id}"
  
    order = build_order_from_session(session)

  
    if order.save
      create_line_items(order, session.id)
      OrderMailer.new_order_admin(order).deliver_now
      OrderMailer.new_order(order).deliver_now
      Rails.logger.info "✅ Order created successfully: #{order.id}"
    else
      Rails.logger.error "❌ Order creation failed: #{order.errors.full_messages.join(', ')}"
    end
  rescue => e
    Rails.logger.error "❌ Error processing session: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
  
  def build_order_from_session(session)
    card_details = retrieve_card_details(session.id)
    Order.new(
      total_price: session.amount_total.to_f / 100,
      status: 'paid',
      date: Time.at(session.created).to_datetime,
      address: session.customer_details.address.line1,
      address_2: session.customer_details.address.line2,
      postal_code: session.customer_details.address.postal_code,
      city: session.customer_details.address.city,
      country: session.customer_details.address.country,
      payment_method: 'Stripe',
      delivery_date: 3.days.from_now,
      paid: true,
      shipping_fee: session.shipping_cost&.amount_total.to_f / 100,
      name: session.customer_details.name,
      email: session.customer_details.email,
      phone: session.customer_details.phone,
      user_id: session.metadata['user_id'],
      discount: session.total_details.amount_discount.to_f / 100 || 0.0,
      card_brand: card_details.brand,
      card_last4: card_details.last4,
      card_exp_month: card_details.exp_month,
      card_exp_year: card_details.exp_year
    )
  end
  
  def create_line_items(order, session_id)
    items = retrieve_line_items(session_id)
  
    Rails.logger.info "Creating line items for order #{order.id} with session ID #{session_id}"
    Rails.logger.info "Line items count: #{items.count}"
  
    items.each do |item|
      # Match your internal product by name (assuming uniqueness)
      product = Product.includes(:images).find_by(name: item.description)
  
      unless product
        Rails.logger.warn "⚠️ No product found for description '#{item.description}'"
        next
      end
  
      LineItem.create!(
        order_id: order.id,
        product_id: product.id,
        name: item.description,
        quantity: item.quantity,
        price: item.amount_total.to_f / item.quantity / 100,
        image: product.images.first&.url || '',
      )
  
      Rails.logger.info "✅ Created line item for order #{order.id}: #{item.description}"
    end
  rescue => e
    Rails.logger.error "❌ Error creating line items: #{e.message}"
  end
  

  def retrieve_line_items(session_id)
    Stripe::Checkout::Session.list_line_items(session_id).data
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "❌ Error retrieving line items for session #{session_id}: #{e.message}"
  end

  def retrieve_card_details(session_id)
    session = Stripe::Checkout::Session.retrieve({
      id: session_id,
      expand: ['payment_intent']
    })
  
    payment_method_id = session.payment_intent.payment_method
    payment_method = Stripe::PaymentMethod.retrieve(payment_method_id)


  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "❌ Stripe error for session #{session_id}: #{e.message}"
    nil
  end
  
  
  
  

  private

  def set_stripe_key
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end
end
