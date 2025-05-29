class Comment < ApplicationRecord

    has_one :product
    has_many :replies, dependent: :destroy
end
