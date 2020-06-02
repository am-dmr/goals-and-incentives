# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_02_125149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dailies", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.bigint "incentive_id"
    t.integer "value", default: 0, null: false
    t.date "date", default: "2020-05-15", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "incentive_status", default: 1, null: false
    t.index ["goal_id"], name: "index_dailies_on_goal_id"
    t.index ["incentive_id"], name: "index_dailies_on_incentive_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "limit", default: 1, null: false
    t.integer "aim", default: 2, null: false
    t.integer "period", default: 1, null: false
    t.integer "size", default: 4, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_completed", default: false, null: false
    t.bigint "incentive_id"
    t.integer "auto_reactivate_every_n_days"
    t.date "auto_reactivate_start_from"
    t.index ["incentive_id"], name: "index_goals_on_incentive_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "incentives", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "size", default: 4, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_incentives_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_visited_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "dailies", "goals"
  add_foreign_key "dailies", "incentives"
  add_foreign_key "goals", "incentives"
  add_foreign_key "goals", "users"
  add_foreign_key "incentives", "users"
end
