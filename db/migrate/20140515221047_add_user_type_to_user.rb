class AddUserTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :permission_level, :string, default: "regular"
  end
end
