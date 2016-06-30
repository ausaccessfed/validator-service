class AddHttpHeaderToFederationAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :federation_attributes, :http_header, :string, null: false
  end
end
