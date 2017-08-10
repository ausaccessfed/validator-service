# frozen_string_literal: true

class SetNotNulls < ActiveRecord::Migration[5.0]
  def change
    change_column_null :category_attributes, :presence, false
    change_column_null :category_attributes, :category_id, false
    change_column_null :category_attributes, :federation_attribute_id, false

    change_column_null :categories, :name, false
    change_column_null :categories, :enabled, false
    change_column_null :categories, :order, false
  end
end
