# frozen_string_literal: true

class EntitlementsForRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :entitlement, :string, null: false, default: ''

    add_index :roles, :entitlement, unique: true
  end
end
