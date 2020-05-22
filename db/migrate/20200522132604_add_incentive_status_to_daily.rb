class AddIncentiveStatusToDaily < ActiveRecord::Migration[6.0]
  def change
    add_column :dailies, :incentive_status, :integer, null: false, default: 1
  end
end
