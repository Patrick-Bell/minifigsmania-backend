class AddAddressesToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :postal_code, :string
    add_column :orders, :city, :string
    add_column :orders, :country, :string
    add_column :orders, :address_2, :string
  end
end
