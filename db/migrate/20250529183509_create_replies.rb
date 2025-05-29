class CreateReplies < ActiveRecord::Migration[7.2]
  def change
    create_table :replies do |t|
      t.string :name
      t.string :message
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
