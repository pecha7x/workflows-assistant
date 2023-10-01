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

ActiveRecord::Schema[7.0].define(version: 2023_09_30_184057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "assistant_configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_assistant_configurations_on_deleted_at"
    t.index ["user_id"], name: "index_assistant_configurations_on_user_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "gmail_messages", force: :cascade do |t|
    t.string "from", null: false
    t.string "subject"
    t.text "body"
    t.string "external_id", null: false
    t.bigint "user_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "external_id", "deleted_at"], name: "index_gmail_messages_on_user_id_and_external_id_and_deleted_at", unique: true
  end

  create_table "job_leads", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "link", null: false
    t.integer "potential", default: 1
    t.integer "status", default: 0
    t.decimal "hourly_rate", precision: 10, scale: 2, null: false
    t.bigint "job_source_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_country", default: "'US'::character varying", null: false
    t.string "external_id", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_job_leads_on_deleted_at"
    t.index ["external_id", "job_source_id"], name: "index_job_leads_on_external_id_and_job_source_id", unique: true
    t.index ["job_source_id"], name: "index_job_leads_on_job_source_id"
  end

  create_table "job_sources", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "kind", default: 0
    t.integer "refresh_rate", default: 60
    t.jsonb "settings"
    t.string "background_job_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_job_sources_on_deleted_at"
    t.index ["user_id"], name: "index_job_sources_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "description", default: "", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["owner_type", "owner_id"], name: "index_notes_on_owner"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifiers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "user_id", null: false
    t.jsonb "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "sanitized_links", default: false, null: false
    t.index ["deleted_at"], name: "index_notifiers_on_deleted_at"
    t.index ["owner_type", "owner_id"], name: "index_notifiers_on_owner"
    t.index ["user_id"], name: "index_notifiers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.datetime "deleted_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.string "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "assistant_configurations", "users"
  add_foreign_key "gmail_messages", "users"
  add_foreign_key "job_leads", "job_sources"
  add_foreign_key "job_sources", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "notifiers", "users"
end
