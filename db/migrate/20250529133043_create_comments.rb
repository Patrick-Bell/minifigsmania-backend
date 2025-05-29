class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.string :name
      t.string :message
      t.integer :likes
      t.integer :dislikes

      t.timestamps
    end
  end
end
