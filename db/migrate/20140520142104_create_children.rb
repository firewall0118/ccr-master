class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.references :family
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :gender
      t.string :race
      t.string :relationship
      t.decimal :qualified_subsidy, precision: 8, scale: 2

      t.timestamps
    end
  end
end
