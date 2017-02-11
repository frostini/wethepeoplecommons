# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170211003106) do

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "url",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "organization_id", limit: 4
    t.text     "description",     limit: 65535, null: false
    t.text     "purpose",         limit: 65535, null: false
    t.string   "urgency",         limit: 255,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["user_id", "organization_id"], name: "index_requests_on_user_id_and_organization_id", using: :btree

  create_table "skill_joins", force: :cascade do |t|
    t.integer  "skill_id",       limit: 4,   null: false
    t.integer  "skillable_id",   limit: 4,   null: false
    t.string   "skillable_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skill_joins", ["skill_id"], name: "index_skill_joins_on_skill_id", using: :btree
  add_index "skill_joins", ["skillable_id", "skillable_type"], name: "index_skill_joins_on_skillable_id_and_skillable_type", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "visitor_id",      limit: 4
    t.string   "email",           limit: 255, null: false
    t.string   "password_digest", limit: 255, null: false
    t.string   "first_name",      limit: 255, null: false
    t.string   "last_name",       limit: 255, null: false
    t.string   "phone",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["visitor_id"], name: "index_users_on_visitor_id", unique: true, using: :btree

  create_table "visitors", force: :cascade do |t|
    t.string   "email",      limit: 255, null: false
    t.string   "group",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "visitors", ["email", "group"], name: "index_visitors_on_email_and_group", unique: true, using: :btree

  create_table "volunteer_profiles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "bio",        limit: 65535
    t.text     "interest",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volunteer_profiles", ["user_id"], name: "index_volunteer_profiles_on_user_id", unique: true, using: :btree

end
