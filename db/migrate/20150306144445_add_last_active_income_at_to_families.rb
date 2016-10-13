class AddLastActiveIncomeAtToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :redetermination_active_at, :datetime
  end
end
