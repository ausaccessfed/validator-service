# frozen_string_literal: true
class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.integer :subject_id
      t.timestamps null: false
    end
  end
end
