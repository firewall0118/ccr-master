class CreateContracts < ActiveRecord::Migration
  def change
    create_table(:contracts) do |t|

    t.integer  :child_id
    t.integer  :provider_id
    t.date     :start_date
    t.date     :end_date
    t.integer  :funding_cycle_id
    t.decimal  :weekly_rate,       precision: 8, scale: 2
    t.decimal  :weekly_parent_fee, precision: 8, scale: 2
    t.decimal  :weekly_subsidy,    precision: 8, scale: 2
    t.decimal  :total_subsidy,     precision: 8, scale: 2
    t.boolean  :provider_accepted
    t.boolean  :funder_accepted
    t.boolean  :family_accepted
    t.boolean  :ccr_accepted
    t.boolean  :cancelled
    t.boolean  :is_full_time
    t.string   :rejection_reason
    t.string   :rejection_note

    t.timestamps
    end
  end
end
