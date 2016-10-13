class AddActiveAtToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :active_at, :datetime
  end
end
