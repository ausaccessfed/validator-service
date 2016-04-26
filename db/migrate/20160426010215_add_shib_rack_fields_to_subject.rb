class AddShibRackFieldsToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :shared_token, :string, null: false
    add_column :subjects, :targeted_id, :string, null: false
    add_column :subjects, :principal_name, :string, null: false
    add_column :subjects, :display_name, :string, null: false
    add_column :subjects, :cn, :string, null: false
    add_column :subjects, :o, :string, null: false
    add_column :subjects, :home_organization, :string, null: false
    add_column :subjects, :home_organization_type, :string, null: false
  end
end
