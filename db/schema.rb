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

ActiveRecord::Schema[7.1].define(version: 2024_11_12_071847) do
  create_table "break_down_structures", force: :cascade do |t|
    t.string "uuid"
    t.string "from"
    t.string "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.string "asset_type"
    t.string "manufacturer"
    t.string "model"
    t.string "serial_number"
  end

  create_table "functional_locations", force: :cascade do |t|
    t.string "uuid"
    t.string "description"
    t.string "status_id"
    t.string "segment_type"
    t.string "id_in_source"
    t.string "short_name"
    t.string "alarm_id"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "break_down_structure_id"
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
    t.string "user_name"
    t.string "password_digest"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "equipment", "functional_locations"
  add_foreign_key "functional_locations", "break_down_structures"
  add_foreign_key "measurements", "equipment"
end
