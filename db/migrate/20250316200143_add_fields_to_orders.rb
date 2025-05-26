class AddFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
    add_column :orders, :platform, :string
  end
end
