class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :username, null: false, default: ''

      t.string :encrypted_password, null: false, default: ''
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
