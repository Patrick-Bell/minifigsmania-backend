class AddNotificationsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :order_notifications, :boolean, default: false
    add_column :users, :promotion_notifications, :boolean, default: false
    add_column :users, :new_product_notifications, :boolean, default: false
    add_column :users, :newsletter_notifications, :boolean, default: false
  end
end
