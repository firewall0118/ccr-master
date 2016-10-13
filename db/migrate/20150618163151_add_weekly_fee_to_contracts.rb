class AddWeeklyFeeToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :weekly_rate, :decimal
    add_column :contracts, :weekly_parent_fee, :decimal
    add_column :contracts, :weekly_subsidy, :decimal
  end
end
