class Product < ApplicationRecord
    has_many :reviews
    has_many :images
end
