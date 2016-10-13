class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.references  :provider_attendance
      t.references  :contract
      t.money       :amount
      t.date        :invoice_date
      t.date        :paid_date
      t.timestamps
    end
  end
end
