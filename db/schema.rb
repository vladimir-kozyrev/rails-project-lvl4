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

ActiveRecord::Schema.define(version: 2022_07_29_045902) do

  create_table "repositories", force: :cascade do |t|
    t.string "link"
    t.string "owner_name"
    t.string "name"
    t.text "description"
    t.string "default_branch"
    t.integer "watchers_count"
    t.string "language"
    t.datetime "repo_created_at"
    t.datetime "repo_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.string "full_name"
    t.integer "github_id", null: false
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "repository_checks", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.integer "repository_id", null: false
    t.text "output"
    t.boolean "passed", default: false
    t.string "commit_hash"
    t.integer "offense_count", default: 0
    t.index ["repository_id"], name: "index_repository_checks_on_repository_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "image_url"
    t.string "name"
    t.string "nickname"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "repositories", "users"
  add_foreign_key "repository_checks", "repositories"
end
