class ChangePayoutAmountFieldType < ActiveRecord::Migration
  def change
    remove_column :payouts, :amount_cents
    remove_column :payouts, :amount_currency
    add_column :payouts, :amount, :decimal, precision: 8, scale: 2, default: 0
  end
end
