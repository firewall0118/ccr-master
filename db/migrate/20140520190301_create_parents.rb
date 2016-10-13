class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.references :family
      t.references :address
      t.string   :order
      t.string   :first_name
      t.string   :last_name
      t.string   :email
      t.string   :race
      t.string   :gender
      t.date     :date_of_birth
      t.string   :marital_status
      t.string   :street
      t.string   :city
      t.string   :state
      t.string   :zip
      t.integer  :county_id
      t.boolean  :has_custody
      t.string   :phone_number_home
      t.string   :phone_number_mobile
      t.string   :phone_number_work
      t.string   :first_job_employer_name
      t.integer  :first_job_weekly_availability
      t.decimal  :first_job_annual_income,          precision: 8, scale: 2
      t.decimal  :first_job_hourly_rate,            precision: 8, scale: 2
      t.string   :second_job_employer_name
      t.integer  :second_job_weekly_availability
      t.decimal  :second_job_annual_income,         precision: 8, scale: 2
      t.decimal  :second_job_hourly_rate,           precision: 8, scale: 2
      t.string   :third_job_employer_name
      t.integer  :third_job_weekly_availability
      t.decimal  :third_job_annual_income,          precision: 8, scale: 2
      t.decimal  :third_job_hourly_rate,            precision: 8, scale: 2

      t.timestamps
    end
  end
end
