class RemoveImagesFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :image, :string
  end
end
