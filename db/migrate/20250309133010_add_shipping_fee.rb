class AddShippingFee < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipping_fee, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
