class ChangeShippingFeeDefaultType < ActiveRecord::Migration[7.2]
  def change
    change_column_default :orders, :shipping_fee, from: "0.0", to: 0.0
  end
end
