class ChangeAmountOffToDecimalInPromotions < ActiveRecord::Migration[7.2]
  def change
    change_column :promotions, :amount_off, :decimal, precision: 8, scale: 2
  end
end
