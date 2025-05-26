class AddCategoryToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :category, :string
  end
end
