class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
    add_column :users, :country, :string, default: 'United Kingdom'
    add_column :users, :phone_number, :string
  end
end
