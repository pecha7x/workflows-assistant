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

ActiveRecord::Schema[7.0].define(version: 2023_08_23_124911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assistant_configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_assistant_configurations_on_user_id"
  end

  create_table "job_feeds", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "kind", default: 0
    t.integer "refresh_rate", default: 60
    t.jsonb "settings"
    t.index ["user_id"], name: "index_job_feeds_on_user_id"
  end

  create_table "job_leads", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "link", null: false
    t.integer "potential", default: 1
    t.integer "status", default: 0
    t.decimal "hourly_rate", precision: 10, scale: 2, null: false
    t.bigint "job_feed_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_feed_id"], name: "index_job_leads_on_job_feed_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assistant_configurations", "users"
  add_foreign_key "job_feeds", "users"
  add_foreign_key "job_leads", "job_feeds"
end
