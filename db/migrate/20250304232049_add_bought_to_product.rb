class AddBoughtToProduct < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :bought, :float
  end
end
