# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_15_212641) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gamestates", force: :cascade do |t|
    t.string "input"
    t.string "output"
    t.bigint "location_id", null: false
    t.bigint "user_id", null: false
    t.index ["location_id"], name: "index_gamestates_on_location_id"
    t.index ["user_id"], name: "index_gamestates_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.bigint "location_id", null: false
    t.index ["location_id"], name: "index_items_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "exits"
    t.boolean "current_location"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end

  add_foreign_key "gamestates", "locations"
  add_foreign_key "gamestates", "users"
  add_foreign_key "items", "locations"
end
