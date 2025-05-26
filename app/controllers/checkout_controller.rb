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

    total_weight = cart.sum { |item| item["weight"] * item["quantity"] }  # weight is in grams
    Rails.logger.debug "Total weight: #{total_weight}g"

    # Determine which shipping options to offer based on weight
    shipping_options = if total_weight < 100
                         # Under 100g, offer the cheaper shipping option
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
                        elsif total_weight >= 100
                         # Over 100g, offer the express shipping option
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
        user_id: current_user&.id || nil,
      },
      shipping_options: shipping_options,
      success_url: 'https://minifigsmania.netlify.app/success',
      cancel_url: 'https://minifigsmania.netlify.app/cancel',
    }
  
    if code.present?
      begin
        coupon = Stripe::Coupon.retrieve(code)
        coupon_name = coupon.id
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
  
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, signing_secret)
    rescue JSON::ParserError
      Rails.logger.error("❌ Invalid JSON")
      return head :bad_request
    rescue Stripe::SignatureVerificationError
      Rails.logger.error("❌ Invalid Signature")
      return head :bad_request
    end
  
    case event.type
    when 'checkout.session.completed'
      session = event.data.object
  
      begin
        Rails.logger.info "Processing checkout.session.completed event"
  

  
        @order = Order.new(
          user_id: session.metadata.user_id || nil,
          total_price: session.amount_total / 100.0,
          status: 'paid',
          date: Time.at(session.created).to_datetime,
          address: session.customer_details.address.to_json,
          payment_method: 'Stripe',
          delivery_date: Time.at(session.created + 3.days).to_datetime,
          paid: true,
          shipping_fee: session.shipping_cost&.amount_total.to_f / 100.0,
          name: session.customer_details.name,
          email: session.customer_details.email,
          phone: session.customer_details.phone,
        )

        if @order.save
          OrderMailer.new_order_admin(@order).deliver_now
          Rails.logger.info "✅ Order created successfully: #{@order.id}"
        else
          Rails.logger.error "❌ Order creation failed: #{@order.errors.full_messages.join(', ')}"
        end

  
      rescue => e
        Rails.logger.error "❌ Error processing checkout.session.completed: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        return head :internal_server_error
      end
    end
  
    head :ok
  end
  
  

  private

  def set_stripe_key
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end


end
