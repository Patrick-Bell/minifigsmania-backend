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

ActiveRecord::Schema[7.2].define(version: 2025_05_21_121136) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "pgsodium"
  create_schema "pgsodium_masks"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_graphql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "pgjwt"
  enable_extension "pgsodium"
  enable_extension "plpgsql"
  enable_extension "supabase_vault"
  enable_extension "uuid-ossp"

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "deadline"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_images_on_product_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "name"
    t.float "price"
    t.integer "quantity"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.boolean "reviewed", default: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "feedback"
    t.integer "rating"
    t.string "issue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.float "total_price"
    t.string "status"
    t.datetime "date"
    t.text "address"
    t.string "payment_method"
    t.datetime "delivery_date"
    t.boolean "paid"
    t.string "order_id"
    t.string "tracking_id"
    t.integer "user_id"
    t.float "shipping_fee"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_wishlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_wishlists_on_product_id"
    t.index ["user_id"], name: "index_product_wishlists_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "stock"
    t.string "team"
    t.string "category"
    t.float "sale_price"
    t.float "height"
    t.float "weight"
    t.string "tag"
    t.string "accessories"
    t.float "bought"
    t.boolean "active", default: false
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "condition"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "code"
    t.integer "percent_off"
    t.string "duration"
    t.string "coupon_id"
    t.datetime "expires_at"
    t.boolean "active", default: false
    t.integer "usage_limit"
    t.integer "redeemed_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "description"
    t.boolean "highlighted", default: false
    t.decimal "amount_off", precision: 8, scale: 2
    t.integer "minimum_spend"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "name"
    t.string "header"
    t.string "text"
    t.integer "rating"
    t.string "platform"
    t.boolean "reviewed"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country", default: "United Kingdom"
    t.string "phone_number"
    t.boolean "order_notifications", default: false
    t.boolean "promotion_notifications", default: false
    t.boolean "new_product_notifications", default: false
    t.boolean "newsletter_notifications", default: false
    t.boolean "is_verified", default: false
    t.string "email_verification_token"
    t.datetime "email_verification_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "images", "products"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "product_wishlists", "products"
  add_foreign_key "product_wishlists", "users"
end
