class AddFieldsToPromotions < ActiveRecord::Migration[7.2]
  def change
    add_column :promotions, :title, :string
    add_column :promotions, :description, :string
    add_column :promotions, :highlighted, :boolean, default: false
  end
end
