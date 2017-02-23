# frozen_string_literal: true
class AddHttpHeaderToFederationAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :http_header, :string, null: false, default: ''

    add_index :federation_attributes, :http_header, unique: true
  end
end
