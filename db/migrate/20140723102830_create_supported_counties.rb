class CreateSupportedCounties < ActiveRecord::Migration
  def change
    create_table :supported_counties do |t|
      t.references :funder
      t.references :county

      t.timestamps
    end
  end
end
