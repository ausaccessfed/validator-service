# frozen_string_literal: true

class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :federation_attributes do |t|
      t.string :name, null: false
      t.string :regexp
      t.boolean :regexp_triggers_failure, default: true, null: false
      t.text :description
      t.string :documentation_url
      t.boolean :singular, default: true, null: false
    end
  end
end
