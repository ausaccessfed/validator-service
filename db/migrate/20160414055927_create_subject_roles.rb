# frozen_string_literal: true
# Migration to create subject_roles table and relevant fields
class CreateSubjectRoles < ActiveRecord::Migration
  def change
    create_table :subject_roles do |t|
      t.integer :role_id, null: false
      t.integer :subject_id, null: false
      t.timestamps null: false
    end
  end
end
