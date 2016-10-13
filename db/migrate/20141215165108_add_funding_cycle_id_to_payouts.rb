class AddFundingCycleIdToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :funding_cycle_id, :integer, null: false
  end
end
