class AddReviewToLineItems < ActiveRecord::Migration[7.2]
  def change
    add_column :line_items, :reviewed, :boolean, default: false
  end
end
