class AddReferenceToReviews < ActiveRecord::Migration[7.2]
  def change
    add_reference :reviews, :product, null: false, foreign_key: true
  end
end
