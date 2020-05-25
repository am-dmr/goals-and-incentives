class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :limit, null: false, default: 1
      t.integer :aim, null: false, default: 2
      t.integer :period, null: false, default: 1
      t.integer :size, null: false, default: 4

      t.timestamps
    end
  end
end
