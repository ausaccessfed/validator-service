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

ActiveRecord::Schema.define(version: 20160418052637) do

  create_table "api_subject_roles", force: :cascade do |t|
    t.integer "role_id",        limit: 4, null: false
    t.integer "api_subject_id", limit: 4, null: false
  end

  add_index "api_subject_roles", ["api_subject_id"], name: "fk_rails_4bb3279f7c", using: :btree
  add_index "api_subject_roles", ["role_id"], name: "fk_rails_3c99dcce56", using: :btree

  create_table "api_subjects", force: :cascade do |t|
    t.string   "x509_cn",      limit: 255,   null: false
    t.text     "description",  limit: 65535, null: false
    t.string   "contact_name", limit: 255,   null: false
    t.string   "contact_mail", limit: 255,   null: false
    t.boolean  "enabled",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "api_subjects", ["x509_cn"], name: "index_api_subjects_on_x509_cn", unique: true, using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "value",      limit: 255, null: false
    t.integer  "role_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "permissions", ["role_id", "value"], name: "index_permissions_on_role_id_and_value", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "subject_roles", force: :cascade do |t|
    t.integer "role_id",    limit: 4, null: false
    t.integer "subject_id", limit: 4, null: false
  end

  add_index "subject_roles", ["role_id"], name: "fk_rails_775c958b0f", using: :btree
  add_index "subject_roles", ["subject_id"], name: "fk_rails_452c5fd0e8", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "mail",       limit: 255, null: false
    t.boolean  "enabled",                null: false
    t.boolean  "complete",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "api_subject_roles", "api_subjects"
  add_foreign_key "api_subject_roles", "roles"
  add_foreign_key "permissions", "roles"
  add_foreign_key "subject_roles", "roles"
  add_foreign_key "subject_roles", "subjects"
end
