class AddEmailFieldsToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_verified, :boolean, default: false
    add_column :users, :email_verification_token, :string
    add_column :users, :email_verification_sent_at, :datetime
  end
end
