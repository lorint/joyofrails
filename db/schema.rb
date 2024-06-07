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

ActiveRecord::Schema[7.1].define(version: 2024_06_07_120410) do
  create_table "_litestream_lock", id: false, force: :cascade do |t|
    t.integer "id"
  end

  create_table "_litestream_seq", force: :cascade do |t|
    t.integer "seq"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "unconfirmed_emails", force: :cascade do |t|
    t.string "email", null: false
    t.integer "user_id", null: false
    t.string "status", default: "0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "email"], name: "index_unconfirmed_emails_on_user_id_and_email", unique: true, where: "status = 0"
    t.index ["user_id"], name: "index_unconfirmed_emails_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "unconfirmed_emails", "users"
end
