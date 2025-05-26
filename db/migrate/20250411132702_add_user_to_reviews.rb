class AddUserToReviews < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :user_id, :integer
  end
end
