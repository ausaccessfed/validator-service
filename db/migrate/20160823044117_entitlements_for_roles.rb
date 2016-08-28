class EntitlementsForRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :entitlement, :string, null: false

    add_index :roles, :entitlement, unique: true
  end
end
