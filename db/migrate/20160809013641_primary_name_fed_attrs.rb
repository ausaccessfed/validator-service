# frozen_string_literal: true

class PrimaryNameFedAttrs < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :primary_alias_id, :integer, null: false, default: ''
    add_index :federation_attributes, :primary_alias_id, unique: true

    add_index :federation_attribute_aliases, %i[federation_attribute_id name], name: :index_faa_on_faid_and_name

    change_column_null :federation_attributes, :oid, false
    remove_index :federation_attributes, :oid
    add_index :federation_attributes, :oid, unique: true

    change_column_null :federation_attribute_aliases, :federation_attribute_id, true
  end
end
