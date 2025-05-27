class AddDiscountToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :discount, :float, default: 0.0
  end
end
