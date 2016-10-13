class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.decimal :alabama_minimum_wage, precision: 8, scale: 2
      t.integer :minimum_work_hours, default: 35
      t.integer :maximum_payout_per_child
      t.date :fiscal_year_start, default: Date.today.beginning_of_year
      t.date :fiscal_year_end, default: Date.today.end_of_year
      t.timestamps
    end
  end
end
