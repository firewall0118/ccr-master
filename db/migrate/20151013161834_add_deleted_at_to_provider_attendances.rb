class AddDeletedAtToProviderAttendances < ActiveRecord::Migration
  def change
    add_column :provider_attendances, :deleted_at, :datetime
    add_index :provider_attendances, :deleted_at
  end
end
