class AddHttpHeaderToFederationAttributes < ActiveRecord::Migration
  def change
    add_column :federation_attributes, :http_header, :string, null: false
  end
end
