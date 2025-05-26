class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :email
      t.string :feedback
      t.integer :rating
      t.string :issue

      t.timestamps
    end
  end
end
