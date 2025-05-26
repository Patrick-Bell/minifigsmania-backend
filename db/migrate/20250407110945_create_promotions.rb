class CreatePromotions < ActiveRecord::Migration[7.2]
  def change
    create_table :promotions do |t|
      t.string :code
      t.integer :percent_off
      t.string :duration
      t.string :coupon_id
      t.datetime :expires_at
      t.boolean :active, default: false
      t.integer :usage_limit
      t.integer :redeemed_count, default: 0

      t.timestamps
    end
  end
end
