class RemoveWeeklyRatesFromContracts < ActiveRecord::Migration
  def change
    remove_column :contracts, :weekly_rate
    remove_column :contracts, :weekly_parent_fee
    remove_column :contracts, :weekly_subsidy
  end
end
