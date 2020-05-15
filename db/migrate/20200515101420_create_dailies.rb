class CreateDailies < ActiveRecord::Migration[6.0]
  def change
    create_table :dailies do |t|
      t.references :goal, null: false, foreign_key: true
      t.references :incentive, null: true, foreign_key: true
      t.integer :value, null: false, default: 0
      t.date :date, null: false, default: Date.current
      t.integer :status, null: false, default: 1

      t.timestamps
    end
  end
end
