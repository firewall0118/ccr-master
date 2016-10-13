class AddClosedToProviderAttendances < ActiveRecord::Migration
  def change
    add_column :provider_attendances, :closed, :boolean, default: false
  end
end
