class RemoveProductsFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :products
  end
end
