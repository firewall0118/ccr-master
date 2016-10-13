class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.integer  :scale_id
      t.string   :case_id
      t.integer  :children_count,                                default: 0
      t.date     :redeterminated_at
      t.date     :redetermination_due_date
      t.string   :redetermination_status

      t.timestamps
    end
  end
end
