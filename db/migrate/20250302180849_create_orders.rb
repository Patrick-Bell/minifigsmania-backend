class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.jsonb :products, default: [] # Array of products with name, quantity, price, image, reviewed
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.string :status, default: "pending" # pending, shipped, delivered
      t.datetime :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.text :address, null: false
      t.string :payment_method, null: false
      t.datetime :delivery_date
      t.boolean :paid, default: false
      t.decimal :shipping_fee, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
