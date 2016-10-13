class AddCategoryToFamilyNotes < ActiveRecord::Migration
  def change
    add_column :family_notes, :category, :string
  end
end
