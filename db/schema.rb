# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151023153445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_groups", force: true do |t|
    t.string   "name"
    t.integer  "min"
    t.integer  "max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "childcare_resources", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "children", force: true do |t|
    t.integer  "family_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "race"
    t.string   "relationship"
    t.decimal  "qualified_subsidy",     precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "weekly_maximum_payout", precision: 8, scale: 2
    t.datetime "deleted_at"
  end

  add_index "children", ["deleted_at"], name: "index_children_on_deleted_at", using: :btree

  create_table "contracts", force: true do |t|
    t.integer  "child_id"
    t.integer  "provider_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "funding_cycle_id"
    t.decimal  "total_subsidy",     precision: 8, scale: 2
    t.boolean  "provider_accepted"
    t.boolean  "funder_accepted"
    t.boolean  "family_accepted"
    t.boolean  "ccr_accepted"
    t.boolean  "cancelled"
    t.boolean  "is_full_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount",                                  default: 0.0
    t.string   "status",                                    default: "in_progress"
    t.decimal  "weekly_rate"
    t.decimal  "weekly_parent_fee"
    t.decimal  "weekly_subsidy"
    t.datetime "deleted_at"
    t.integer  "transferred_from"
  end

  add_index "contracts", ["deleted_at"], name: "index_contracts_on_deleted_at", using: :btree

  create_table "counties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "county_rates", force: true do |t|
    t.integer  "county_id"
    t.integer  "provider_type_id"
    t.decimal  "part_time_toddler_weekly_rate"
    t.decimal  "part_time_infant_weekly_rate"
    t.decimal  "part_time_school_weekly_rate"
    t.decimal  "part_time_preschool_weekly_rate"
    t.decimal  "full_time_toddler_weekly_rate"
    t.decimal  "full_time_infant_weekly_rate"
    t.decimal  "full_time_school_weekly_rate"
    t.decimal  "full_time_preschool_weekly_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "families", force: true do |t|
    t.integer  "scale_id"
    t.string   "case_id"
    t.integer  "children_count",            default: 0
    t.date     "redeterminated_at"
    t.date     "redetermination_due_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "redetermination_active_at"
    t.string   "rejection_reason"
    t.text     "rejection_note"
    t.datetime "deleted_at"
  end

  add_index "families", ["deleted_at"], name: "index_families_on_deleted_at", using: :btree

  create_table "family_notes", force: true do |t|
    t.integer  "user_id"
    t.integer  "family_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "funders", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone_number"
    t.string   "contact_person"
    t.integer  "max_family_size"
    t.string   "email"
    t.text     "notes"
    t.string   "abbreviation"
    t.boolean  "active"
    t.decimal  "amount",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funding_cycles", force: true do |t|
    t.integer  "funder_id"
    t.decimal  "amount",     precision: 8, scale: 2
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parents", force: true do |t|
    t.integer  "family_id"
    t.integer  "address_id"
    t.string   "order"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "race"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "county_id"
    t.boolean  "has_custody"
    t.string   "phone_number_home"
    t.string   "phone_number_mobile"
    t.string   "phone_number_work"
    t.string   "first_job_employer_name"
    t.integer  "first_job_weekly_availability"
    t.decimal  "first_job_annual_income",        precision: 8, scale: 2
    t.decimal  "first_job_hourly_rate",          precision: 8, scale: 2
    t.string   "second_job_employer_name"
    t.integer  "second_job_weekly_availability"
    t.decimal  "second_job_annual_income",       precision: 8, scale: 2
    t.decimal  "second_job_hourly_rate",         precision: 8, scale: 2
    t.string   "third_job_employer_name"
    t.integer  "third_job_weekly_availability"
    t.decimal  "third_job_annual_income",        precision: 8, scale: 2
    t.decimal  "third_job_hourly_rate",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payouts", force: true do |t|
    t.integer  "provider_attendance_id"
    t.integer  "contract_id"
    t.date     "invoice_date"
    t.date     "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "funding_cycle_id",                                             null: false
    t.decimal  "amount",                 precision: 8, scale: 2, default: 0.0
  end

  create_table "provider_attendances", force: true do |t|
    t.integer  "contract_id"
    t.integer  "provider_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "days",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",      default: false
    t.datetime "deleted_at"
  end

  add_index "provider_attendances", ["deleted_at"], name: "index_provider_attendances_on_deleted_at", using: :btree

  create_table "provider_rates", force: true do |t|
    t.integer  "provider_id"
    t.decimal  "part_time_toddler_weekly_rate",          precision: 8, scale: 2
    t.decimal  "part_time_infant_weekly_rate",           precision: 8, scale: 2
    t.decimal  "part_time_school_weekly_rate",           precision: 8, scale: 2
    t.decimal  "part_time_preschool_weekly_rate",        precision: 8, scale: 2
    t.decimal  "part_time_sibling_discount_flat_amount", precision: 8, scale: 2
    t.integer  "part_time_sibling_discount_percentage"
    t.decimal  "full_time_toddler_weekly_rate",          precision: 8, scale: 2
    t.decimal  "full_time_infant_weekly_rate",           precision: 8, scale: 2
    t.decimal  "full_time_school_weekly_rate",           precision: 8, scale: 2
    t.decimal  "full_time_preschool_weekly_rate",        precision: 8, scale: 2
    t.decimal  "full_time_sibling_discount_flat_amount", precision: 8, scale: 2
    t.integer  "full_time_sibling_discount_percentage"
    t.boolean  "part_time_discount_is_fixed",                                    default: false
    t.boolean  "full_time_discount_is_fixed",                                    default: false
    t.date     "effective_date"
    t.date     "end_date"
    t.boolean  "has_sibling_discounts",                                          default: false
    t.boolean  "boolean",                                                        default: false
    t.text     "additional_discount_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "vendor_number"
    t.string   "phone_number"
    t.string   "alternate_phone_number"
    t.string   "fax_number"
    t.string   "website"
    t.string   "director_name"
    t.string   "assistant_director_name"
    t.string   "physical_address_street"
    t.string   "physical_address_city"
    t.string   "physical_address_state"
    t.string   "physical_address_zip"
    t.string   "mailing_address_street"
    t.string   "mailing_address_city"
    t.string   "mailing_address_state"
    t.string   "mailing_address_zip"
    t.string   "provider_license_type"
    t.string   "license_number"
    t.date     "license_issue_date"
    t.date     "license_expiration_date"
    t.date     "license_exempt_expiration_date"
    t.boolean  "has_sibling_discounts",                                          default: false
    t.decimal  "sibling_discount_flat_amount"
    t.integer  "sibling_discount_percentage"
    t.text     "additional_discount_notes"
    t.decimal  "sibling_discount_part_time_flat_amount"
    t.integer  "sibling_discount_part_time_percentage"
    t.integer  "provider_type_id"
    t.integer  "county_id"
    t.decimal  "amount_due",                             precision: 8, scale: 2
    t.integer  "children_count"
    t.integer  "closed_months",                                                  default: [],    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scales", force: true do |t|
    t.integer "family_size"
    t.decimal "minimum_income", precision: 8, scale: 2
    t.decimal "maximum_income", precision: 8, scale: 2
  end

  create_table "settings", force: true do |t|
    t.decimal  "alabama_minimum_wage",     precision: 8, scale: 2
    t.integer  "minimum_work_hours",                               default: 35
    t.integer  "maximum_payout_per_child"
    t.date     "fiscal_year_start",                                default: '2016-01-01'
    t.date     "fiscal_year_end",                                  default: '2016-12-31'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supported_counties", force: true do |t|
    t.integer  "funder_id"
    t.integer  "county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permission_level",       default: "regular"
    t.string   "job"
    t.string   "phone_number"
    t.string   "phone_ext"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.datetime "active_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
