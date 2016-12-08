# frozen_string_literal: true
# Migration to create roles table and relevant fields
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
