class AddTeamToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :team, :string
  end
end
