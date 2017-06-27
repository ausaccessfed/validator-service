# frozen_string_literal: true

class CreateCategoryAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :category_attributes do |t|
      t.boolean :presence
      t.references :category, foreign_key: true
      t.references :federation_attribute, foreign_key: true

      t.timestamps
    end
  end
end
