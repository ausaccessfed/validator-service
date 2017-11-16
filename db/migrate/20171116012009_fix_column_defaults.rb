class FixColumnDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default :federation_attributes, :http_header, ''
    change_column_default :federation_attributes, :internal_alias, ''
    change_column_default :roles, :entitlement, ''
    change_column_default :subjects, :persistent_id, ''
  end
end
