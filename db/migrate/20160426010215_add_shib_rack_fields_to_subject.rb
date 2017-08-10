# frozen_string_literal: true

class AddShibRackFieldsToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :targeted_id, :string, null: false, default: ''
  end
end
