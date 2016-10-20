class FederationAttributeName < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :primary_alias_name, :string

    FederationAttribute.all.each { |fa| fa.sync_name }
  end
end