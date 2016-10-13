class CreateFamilyNotes < ActiveRecord::Migration
  def change
    create_table :family_notes do |t|
      t.references :user
      t.references :family
      t.text :content

      t.timestamps
    end
  end
end
