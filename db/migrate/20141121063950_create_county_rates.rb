class CreateCountyRates < ActiveRecord::Migration
  def change
    create_table :county_rates do |t|
      t.references :county
      t.references :provider_type
      t.decimal :part_time_toddler_weekly_rate
      t.decimal :part_time_infant_weekly_rate
      t.decimal :part_time_school_weekly_rate
      t.decimal :part_time_preschool_weekly_rate
      t.decimal :full_time_toddler_weekly_rate
      t.decimal :full_time_infant_weekly_rate
      t.decimal :full_time_school_weekly_rate
      t.decimal :full_time_preschool_weekly_rate

      t.timestamps
    end
  end
end
