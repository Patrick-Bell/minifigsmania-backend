# config/initializers/stripe.rb
Stripe.api_key = if Rails.env.production?
    ENV['STRIPE_SECRET_KEY']
  else
    ENV['STRIPE_API_KEY']
  end

raise "Stripe API key is missing!" unless Stripe.api_key.present?
