class CreateAgeGroups < ActiveRecord::Migration
  def change
    create_table :age_groups do |t|
      t.string :name
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end
