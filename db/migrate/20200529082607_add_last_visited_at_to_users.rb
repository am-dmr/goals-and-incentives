class AddLastVisitedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_visited_at, :datetime
  end
end
