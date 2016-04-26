class CreateAffiliationsTable < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.integer :subject_id, null: false
      t.string :value, null: false
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
  end
end
