class RemoveShippingFee < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :shipping_fee
  end
end
