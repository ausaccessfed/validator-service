# frozen_string_literal: true

class CreateSnapshotAttributeValues < ActiveRecord::Migration[4.2]
  def change
    create_table :snapshot_attribute_values do |t|
      t.integer :snapshot_id, null: false
      t.integer :attribute_value_id, null: false
      t.timestamps null: false
    end
  end
end
