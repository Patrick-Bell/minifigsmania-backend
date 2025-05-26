class AddFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :sale_price, :float
    add_column :products, :height, :float
    add_column :products, :weight, :float
    add_column :products, :tag, :string
  end
end
