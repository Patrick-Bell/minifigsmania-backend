class ChangeProductsToJsonbInOrders < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :products, :jsonb, using: 'products::jsonb', default: [], null: false
  end
end
