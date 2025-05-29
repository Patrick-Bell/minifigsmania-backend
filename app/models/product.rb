class Product < ApplicationRecord
    has_many :reviews
    has_many :images
    has_many :comments
end
