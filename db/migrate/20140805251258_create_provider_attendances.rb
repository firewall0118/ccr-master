class CreateProviderAttendances < ActiveRecord::Migration
  def change
    create_table :provider_attendances do |t|
      t.references :contract
      t.references :provider
      t.integer :year
      t.integer :month
      t.integer :days, default: 0
      t.timestamps
    end
  end
end
