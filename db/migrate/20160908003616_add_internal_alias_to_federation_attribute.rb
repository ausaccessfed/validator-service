class AddInternalAliasToFederationAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :internal_alias, :string, null: false
    add_index :federation_attributes, :internal_alias, unique: true
  end
end
