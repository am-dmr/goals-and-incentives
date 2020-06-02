class AddAutomaticReactivationToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :auto_reactivate_every_n_days, :integer
    add_column :goals, :auto_reactivate_start_from, :date
  end
end
