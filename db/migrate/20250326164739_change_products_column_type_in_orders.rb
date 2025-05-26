class ChangeProductsColumnTypeInOrders < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :products, :text
  end
end
