class AddIsCompletedToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :is_completed, :boolean, null: false, default: false
  end
end
