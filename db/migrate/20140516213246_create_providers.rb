class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string   :name
      t.string   :email
      t.string   :vendor_number
      t.string   :phone_number
      t.string   :alternate_phone_number
      t.string   :fax_number
      t.string   :website
      t.string   :director_name
      t.string   :assistant_director_name
      t.string   :physical_address_street
      t.string   :physical_address_city
      t.string   :physical_address_state
      t.string   :physical_address_zip
      t.string   :mailing_address_street
      t.string   :mailing_address_city
      t.string   :mailing_address_state
      t.string   :mailing_address_zip
      t.string   :provider_license_type
      t.string   :license_number
      t.date     :license_issue_date
      t.date     :license_expiration_date
      t.date     :license_exempt_expiration_date
      t.boolean  :has_sibling_discounts,                  default: false
      t.decimal  :sibling_discount_flat_amount
      t.integer  :sibling_discount_percentage
      t.text     :additional_discount_notes
      t.decimal  :sibling_discount_part_time_flat_amount
      t.integer  :sibling_discount_part_time_percentage
      t.integer  :provider_type_id
      t.integer  :county_id
      t.decimal  :amount_due,                             precision: 8, scale: 2
      t.integer  :children_count
      t.integer  :closed_months, array: true, default: []
      t.timestamps
    end
  end
end
