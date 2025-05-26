class CreateLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :name
      t.float :price
      t.integer :quantity
      t.string :image

      t.timestamps
    end
  end
end
