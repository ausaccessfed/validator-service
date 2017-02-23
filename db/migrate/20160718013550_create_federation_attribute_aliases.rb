# frozen_string_literal: true
class CreateFederationAttributeAliases < ActiveRecord::Migration[5.0]
  def change
    create_table :federation_attribute_aliases do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.references :federation_attribute, foreign_key: true, null: false

      t.timestamps
    end

    add_column :federation_attributes, :oid, :string
    add_index :federation_attributes, :oid, unique: true

    remove_column :federation_attributes, :name, :string
  end
end
