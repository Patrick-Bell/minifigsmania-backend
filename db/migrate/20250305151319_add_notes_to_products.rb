class AddNotesToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :notes, :string
  end
end
