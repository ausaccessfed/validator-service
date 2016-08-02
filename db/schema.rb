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

ActiveRecord::Schema.define(version: 20160718013550) do

  create_table "api_subject_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "role_id",        null: false
    t.integer  "api_subject_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["api_subject_id"], name: "fk_rails_4bb3279f7c", using: :btree
    t.index ["role_id"], name: "fk_rails_3c99dcce56", using: :btree
  end

  create_table "api_subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "x509_cn",                    null: false
    t.text     "description",  limit: 65535, null: false
    t.string   "contact_name",               null: false
    t.string   "contact_mail",               null: false
    t.boolean  "enabled",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["x509_cn"], name: "index_api_subjects_on_x509_cn", unique: true, using: :btree
  end

  create_table "attribute_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.text     "value",                   limit: 65535, null: false
    t.integer  "federation_attribute_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",                      null: false
    t.text     "description", limit: 65535
    t.string   "url"
    t.boolean  "enabled",                   null: false
    t.integer  "order",                     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["order"], name: "index_categories_on_order", unique: true, using: :btree
  end

  create_table "category_attributes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.boolean  "presence",                null: false
    t.integer  "category_id",             null: false
    t.integer  "federation_attribute_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["category_id"], name: "index_category_attributes_on_category_id", using: :btree
    t.index ["federation_attribute_id"], name: "index_category_attributes_on_federation_attribute_id", using: :btree
  end

  create_table "federation_attribute_aliases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",                    null: false
    t.integer  "federation_attribute_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["federation_attribute_id"], name: "index_federation_attribute_aliases_on_federation_attribute_id", using: :btree
    t.index ["name"], name: "index_federation_attribute_aliases_on_name", unique: true, using: :btree
  end

  create_table "federation_attributes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string  "regexp"
    t.boolean "regexp_triggers_failure",               default: true, null: false
    t.text    "description",             limit: 65535
    t.boolean "singular",                              default: true, null: false
    t.string  "http_header",                                          null: false
    t.text    "notes_on_format",         limit: 65535
    t.text    "notes_on_usage",          limit: 65535
    t.text    "notes_on_privacy",        limit: 65535
    t.string  "oid"
    t.index ["http_header"], name: "index_federation_attributes_on_http_header", unique: true, using: :btree
    t.index ["oid"], name: "index_federation_attributes_on_oid", unique: true, using: :btree
  end

  create_table "permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "value",      null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "value"], name: "index_permissions_on_role_id_and_value", unique: true, using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snapshot_attribute_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "snapshot_id",        null: false
    t.integer  "attribute_value_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "role_id",    null: false
    t.integer  "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "fk_rails_775c958b0f", using: :btree
    t.index ["subject_id"], name: "fk_rails_452c5fd0e8", using: :btree
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "name",        null: false
    t.string   "mail",        null: false
    t.boolean  "enabled",     null: false
    t.boolean  "complete",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "targeted_id", null: false
  end

  add_foreign_key "api_subject_roles", "api_subjects"
  add_foreign_key "api_subject_roles", "roles"
  add_foreign_key "category_attributes", "categories"
  add_foreign_key "category_attributes", "federation_attributes"
  add_foreign_key "federation_attribute_aliases", "federation_attributes"
  add_foreign_key "permissions", "roles"
  add_foreign_key "subject_roles", "roles"
  add_foreign_key "subject_roles", "subjects"
end
