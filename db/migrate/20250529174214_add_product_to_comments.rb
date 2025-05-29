class AddProductToComments < ActiveRecord::Migration[7.2]
  def change
    add_reference :comments, :product, null: false, foreign_key: true
  end
end
