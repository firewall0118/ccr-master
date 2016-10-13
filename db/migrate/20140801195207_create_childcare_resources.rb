class CreateChildcareResources < ActiveRecord::Migration
  def change
    create_table :childcare_resources do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
