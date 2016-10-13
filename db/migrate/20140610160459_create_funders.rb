class CreateFunders < ActiveRecord::Migration
  def change
    create_table :funders do |t|
      t.string   :name
      t.string   :address
      t.string   :phone_number
      t.string   :contact_person
      t.integer  :max_family_size
      t.string   :email
      t.text     :notes
      t.string   :abbreviation
      t.boolean  :active
      t.decimal  :amount,          precision: 8, scale: 2

      t.timestamps
    end
  end
end
