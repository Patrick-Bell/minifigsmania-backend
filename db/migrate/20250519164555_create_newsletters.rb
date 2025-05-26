class CreateNewsletters < ActiveRecord::Migration[7.2]
  def change
    create_table :newsletters do |t|
      t.string :email

      t.timestamps
    end
  end
end
