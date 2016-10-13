class MoveRejectionFieldsToFamilies < ActiveRecord::Migration
  def change
    remove_column :contracts, :rejection_reason, :string
    remove_column :contracts, :rejection_note, :text

    add_column :contracts, :status, :string

    add_column :families, :rejection_reason, :string
    add_column :families, :rejection_note, :text

    rename_column :families, :redetermination_status, :status
  end
end
