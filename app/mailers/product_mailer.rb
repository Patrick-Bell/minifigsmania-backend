class ProductMailer < ApplicationMailer
    include Rails.application.routes.url_helpers
  
    def new_product_listed(product)
      @product = product
  
      @first_image_url = @product.images.first['url'] # Assuming `images` is an array of hashes

  
      # Send the email
      mail(to: ENV['MINIFIGSMANIA_EMAIL'], subject: "MinifigsMania | New Product Listed") do |format|
        format.html { render 'new_product_listed' } # Your HTML email template
        format.text { render plain: 'New product information' }
      end
    end
  end
  