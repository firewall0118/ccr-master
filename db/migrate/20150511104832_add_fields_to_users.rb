class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job, :string
    add_column :users, :phone_number, :string
    add_column :users, :phone_ext, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :middle_name, :string
  end
end
