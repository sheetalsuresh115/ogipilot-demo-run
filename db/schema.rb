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

ActiveRecord::Schema[7.1].define(version: 2024_08_27_022210) do
  create_table "equipment", force: :cascade do |t|
    t.string "uuid"
    t.string "id_in_source"
    t.string "functional_location_id"
    t.string "segment_uuid"
    t.string "site_id"
    t.string "short_name"
    t.string "properties"
    t.string "installed_at"
    t.string "datetime"
    t.string "uninstalled_at"
    t.string "category"
    t.string "bod_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_id"
    t.string "alarm_id"
    t.boolean "is_active"
  end

  create_table "measurements", force: :cascade do |t|
    t.integer "equipment_id", null: false
    t.string "time_stamp"
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_measurements_on_equipment_id"
  end

  create_table "ogi_pilot_sessions", force: :cascade do |t|
    t.string "consumer_session_id"
    t.string "end_point"
    t.string "channel"
    t.string "topic"
    t.string "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider_session_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "measurements", "equipment"
end
