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

ActiveRecord::Schema[7.0].define(version: 2022_04_24_203548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "fields", force: :cascade do |t|
    t.string "title"
    t.string "key"
    t.string "column_type"
    t.boolean "permanent", default: false
    t.boolean "publish", default: true
    t.boolean "same_across_set", default: false
    t.boolean "item_identifier", default: false
    t.bigint "prefix_field_id"
    t.bigint "suffix_field_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_format"
    t.string "currency_iso_code"
    t.string "number_format"
    t.string "bootstrap_col", default: "col-12"
    t.integer "position"
    t.boolean "divider", default: false
    t.index ["deleted_at"], name: "index_fields_on_deleted_at"
    t.index ["prefix_field_id"], name: "index_fields_on_prefix_field_id"
    t.index ["suffix_field_id"], name: "index_fields_on_suffix_field_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "item_set_id"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "processed_at"
    t.index ["deleted_at"], name: "index_images_on_deleted_at"
    t.index ["item_id"], name: "index_images_on_item_id"
    t.index ["item_set_id"], name: "index_images_on_item_set_id"
  end

  create_table "item_sets", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.jsonb "log"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_item_sets_on_deleted_at"
    t.index ["log"], name: "index_item_sets_on_log"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "item_set_id", null: false
    t.string "slug"
    t.jsonb "data", default: {}
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "search_data"
    t.virtual "search_tsvector_col", type: :tsvector, as: "to_tsvector('english'::regconfig, search_data)", stored: true
    t.index ["data"], name: "index_items_on_data"
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
    t.index ["item_set_id"], name: "index_items_on_item_set_id"
    t.index ["slug"], name: "index_items_on_slug", unique: true
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "model_id"
    t.string "model_type"
    t.bigint "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "action"
    t.jsonb "entry"
    t.integer "version", default: 0
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "index_logs_on_associated_type_and_associated_id"
    t.index ["created_at"], name: "index_logs_on_created_at"
    t.index ["entry"], name: "index_logs_on_entry", using: :gin
    t.index ["model_type", "model_id", "version"], name: "index_logs_on_model_type_and_model_id_and_version"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "multiple_selects", force: :cascade do |t|
    t.bigint "field_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id", "title"], name: "index_multiple_selects_on_field_id_and_title", unique: true
    t.index ["field_id"], name: "index_multiple_selects_on_field_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_pages_on_deleted_at"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "single_selects", force: :cascade do |t|
    t.bigint "field_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id", "title"], name: "index_single_selects_on_field_id_and_title", unique: true
    t.index ["field_id"], name: "index_single_selects_on_field_id"
  end

  create_table "sorts", force: :cascade do |t|
    t.bigint "view_id", null: false
    t.bigint "field_id", null: false
    t.string "direction"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_sorts_on_field_id"
    t.index ["view_id"], name: "index_sorts_on_view_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.jsonb "settings", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_fields", force: :cascade do |t|
    t.bigint "view_id", null: false
    t.bigint "field_id", null: false
    t.integer "position"
    t.index ["field_id"], name: "index_view_fields_on_field_id"
    t.index ["position"], name: "index_view_fields_on_position"
    t.index ["view_id", "field_id"], name: "index_view_fields_on_view_id_and_field_id", unique: true
    t.index ["view_id"], name: "index_view_fields_on_view_id"
  end

  create_table "views", force: :cascade do |t|
    t.string "title"
    t.boolean "default", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_views_on_deleted_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fields", "fields", column: "prefix_field_id"
  add_foreign_key "fields", "fields", column: "suffix_field_id"
  add_foreign_key "images", "item_sets"
  add_foreign_key "images", "items"
  add_foreign_key "items", "item_sets"
  add_foreign_key "multiple_selects", "fields"
  add_foreign_key "single_selects", "fields"
  add_foreign_key "sorts", "fields"
  add_foreign_key "sorts", "views"
  add_foreign_key "view_fields", "fields"
  add_foreign_key "view_fields", "views"
end
