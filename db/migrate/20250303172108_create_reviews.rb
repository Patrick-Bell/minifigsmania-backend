class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.string :name
      t.string :header
      t.string :text
      t.integer :rating, default: 5
      t.string :platform
      t.boolean :reviewed, default: false

      t.timestamps
    end
  end
end
