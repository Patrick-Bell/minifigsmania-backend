class AddAmountOfToPromotions < ActiveRecord::Migration[7.2]
  def change
    add_column :promotions, :amount_off, :integer
  end
end
