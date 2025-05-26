class AddMinimumSpendPromotions < ActiveRecord::Migration[7.2]
  def change
    add_column :promotions, :minimum_spend, :integer
  end
end
