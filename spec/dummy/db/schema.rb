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

ActiveRecord::Schema[8.0].define(version: 2025_02_14_162622) do
  create_table "inner_performance_events", force: :cascade do |t|
    t.string "event"
    t.string "name"
    t.decimal "duration"
    t.decimal "db_runtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "properties"
    t.string "type"
  end

  create_table "inner_performance_traces", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "name"
    t.string "type"
    t.json "payload", default: {}
    t.decimal "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_inner_performance_traces_on_event_id"
  end

  add_foreign_key "inner_performance_traces", "inner_performance_events", column: "event_id"
end
