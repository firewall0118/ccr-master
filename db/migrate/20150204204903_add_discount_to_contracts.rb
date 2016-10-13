class AddDiscountToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :discount, :decimal, default: 0
  end
end
