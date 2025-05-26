class AddRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :role)
    add_column :users, :role, :string
    end
  end
end
