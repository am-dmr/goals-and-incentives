class CreateIncentives < ActiveRecord::Migration[6.0]
  def change
    create_table :incentives do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :size, null: false, default: 4

      t.timestamps
    end
  end
end
