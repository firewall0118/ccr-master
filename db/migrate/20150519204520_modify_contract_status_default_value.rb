class ModifyContractStatusDefaultValue < ActiveRecord::Migration
  def change
    change_column :contracts, :status, :string, default: 'in_progress'
  end
end
