class Review < ApplicationRecord
    has_one :product

    belongs_to :user, optional: true
end
