class CreateScales < ActiveRecord::Migration
  def change
    create_table :scales do |t|
      t.integer :family_size
      t.decimal :minimum_income, precision: 8, scale: 2
      t.decimal :maximum_income, precision: 8, scale: 2
    end
  end
end
