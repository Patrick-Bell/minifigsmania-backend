class ReviewMailer < ApplicationMailer

    def new_review(review)

        @review = review
        @product = Product.find_by(id: @review.product_id)
        @first_image_url = @product.images.first['url'] # Assuming `images` is an array of hashes
        @user = User.find_by(id: @review.user_id)

        mail(to: ENV['EMAIL'], subject: "MinifigsMania | New Review")

    end
end
