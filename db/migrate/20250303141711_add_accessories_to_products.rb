class AddAccessoriesToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :accessories, :string
  end
end
