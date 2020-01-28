# frozen_string_literal: true

# Migration to create permissions table and relevant fields
class CreatePermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :permissions do |t|
      t.string :value, null: false
      t.integer :role_id, null: false
      t.timestamps null: false
      t.index %i[role_id value], unique: true
    end
  end
end
