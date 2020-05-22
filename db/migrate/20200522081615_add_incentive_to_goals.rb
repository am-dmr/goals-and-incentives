class AddIncentiveToGoals < ActiveRecord::Migration[6.0]
  def change
    add_reference :goals, :incentive, index: true, foreign_key: true, null: true
  end
end
