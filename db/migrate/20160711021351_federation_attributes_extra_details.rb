class FederationAttributesExtraDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :notes_on_format, :text
    add_column :federation_attributes, :notes_on_usage, :text
    add_column :federation_attributes, :notes_on_privacy, :text

    remove_column :federation_attributes, :documentation_url
  end
end
