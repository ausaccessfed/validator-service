# frozen_string_literal: true
class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.text :value, null: false
      t.integer :federation_attribute_id
      t.timestamps null: false
    end
  end
end
