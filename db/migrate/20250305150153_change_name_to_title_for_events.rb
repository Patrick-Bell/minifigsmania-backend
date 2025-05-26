class ChangeNameToTitleForEvents < ActiveRecord::Migration[7.2]
  def change
    rename_column :events, :name, :title
  end
end
