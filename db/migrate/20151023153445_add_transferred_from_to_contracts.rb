class AddTransferredFromToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :transferred_from, :integer
  end
end
