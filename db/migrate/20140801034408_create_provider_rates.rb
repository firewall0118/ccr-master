class CreateProviderRates < ActiveRecord::Migration
  def change
    create_table :provider_rates do |t|
      t.references  :provider
      t.decimal :part_time_toddler_weekly_rate,           precision: 8, scale: 2
      t.decimal :part_time_infant_weekly_rate,            precision: 8, scale: 2
      t.decimal :part_time_school_weekly_rate,            precision: 8, scale: 2
      t.decimal :part_time_preschool_weekly_rate,         precision: 8, scale: 2
      t.decimal :part_time_sibling_discount_flat_amount,  precision: 8, scale: 2
      t.integer :part_time_sibling_discount_percentage

      t.decimal :full_time_toddler_weekly_rate,           precision: 8, scale: 2
      t.decimal :full_time_infant_weekly_rate,            precision: 8, scale: 2
      t.decimal :full_time_school_weekly_rate,            precision: 8, scale: 2
      t.decimal :full_time_preschool_weekly_rate,         precision: 8, scale: 2
      t.decimal :full_time_sibling_discount_flat_amount,  precision: 8, scale: 2
      t.integer :full_time_sibling_discount_percentage

      t.boolean :part_time_discount_is_fixed, default: false
      t.boolean :full_time_discount_is_fixed, default: false

      t.date  :effective_date
      t.date  :end_date

      t.boolean :has_sibling_discounts, :boolean, default: false
      t.text :additional_discount_notes

      t.timestamps
    end
  end
end
