class ChangeProductsToJsonInOrders < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :products, :jsonb, default: [], using: 'products::jsonb'
  end
end
