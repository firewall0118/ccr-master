class AddMaximumPayOutPerChild < ActiveRecord::Migration
  def change
    add_column :children, :weekly_maximum_payout, :decimal, precision: 8, scale: 2
  end
end
