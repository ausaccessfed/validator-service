# frozen_string_literal: true

class AddForeignKeys < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :permissions, :roles
    add_foreign_key :subject_roles, :roles
    add_foreign_key :subject_roles, :subjects
    add_foreign_key :api_subject_roles, :roles
    add_foreign_key :api_subject_roles, :api_subjects
  end
end
