# frozen_string_literal: true
# Migration to create api_subject_roles table and relevant fields
class CreateAPISubjectRoles < ActiveRecord::Migration
  def change
    create_table :api_subject_roles do |t|
      t.integer :role_id, null: false
      t.integer :api_subject_id, null: false
      t.timestamps null: false
    end
  end
end
