class AddCardDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :card_brand, :string
    add_column :orders, :card_last4, :string
    add_column :orders, :card_exp_month, :integer
    add_column :orders, :card_exp_year, :integer
  end
end
