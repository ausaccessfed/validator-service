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

ActiveRecord::Schema.define(version: 2017_11_16_012009) do

  create_table "api_subject_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "api_subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_subject_id"], name: "fk_rails_4bb3279f7c"
    t.index ["role_id"], name: "fk_rails_3c99dcce56"
  end

  create_table "api_subjects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "x509_cn", null: false
    t.text "description", null: false
    t.string "contact_name", null: false
    t.string "contact_mail", null: false
    t.boolean "enabled", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["x509_cn"], name: "index_api_subjects_on_x509_cn", unique: true
  end

  create_table "attribute_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.text "value", null: false
    t.integer "federation_attribute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "url"
    t.boolean "enabled", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order"], name: "index_categories_on_order", unique: true
  end

  create_table "category_attributes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.boolean "presence", null: false
    t.integer "category_id", null: false
    t.integer "federation_attribute_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_attributes_on_category_id"
    t.index ["federation_attribute_id"], name: "index_category_attributes_on_federation_attribute_id"
  end

  create_table "federation_attribute_aliases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name", null: false
    t.integer "federation_attribute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["federation_attribute_id", "name"], name: "index_faa_on_faid_and_name"
    t.index ["federation_attribute_id"], name: "index_federation_attribute_aliases_on_federation_attribute_id"
    t.index ["name"], name: "index_federation_attribute_aliases_on_name", unique: true
  end

  create_table "federation_attributes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "regexp"
    t.boolean "regexp_triggers_failure", default: true, null: false
    t.text "description"
    t.boolean "singular", default: true, null: false
    t.string "http_header", default: "", null: false
    t.text "notes_on_format"
    t.text "notes_on_usage"
    t.text "notes_on_privacy"
    t.string "oid", null: false
    t.integer "primary_alias_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "internal_alias", default: "", null: false
    t.string "primary_alias_name"
    t.index ["http_header"], name: "index_federation_attributes_on_http_header", unique: true
    t.index ["internal_alias"], name: "index_federation_attributes_on_internal_alias", unique: true
    t.index ["oid"], name: "index_federation_attributes_on_oid", unique: true
    t.index ["primary_alias_id"], name: "index_federation_attributes_on_primary_alias_id", unique: true
  end

  create_table "permissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "value", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "value"], name: "index_permissions_on_role_id_and_value", unique: true
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "entitlement", default: "", null: false
    t.index ["entitlement"], name: "index_roles_on_entitlement", unique: true
  end

  create_table "snapshot_attribute_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.integer "snapshot_id", null: false
    t.integer "attribute_value_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snapshots", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "fk_rails_775c958b0f"
    t.index ["subject_id"], name: "fk_rails_452c5fd0e8"
  end

  create_table "subjects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "mail", null: false
    t.boolean "enabled", null: false
    t.boolean "complete", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "persistent_id", default: "", null: false
    t.index ["persistent_id"], name: "index_subjects_on_persistent_id", unique: true
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
