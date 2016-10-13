class CreateFundingCycles < ActiveRecord::Migration
  def change
    create_table :funding_cycles do |t|
      t.references :funder
      t.decimal    :amount, precision: 8, scale: 2
      t.date       :start_date
      t.date       :end_date
      t.text       :notes

      t.timestamps
    end
  end
end
