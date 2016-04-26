class CreateScopedAffiliationsTable < ActiveRecord::Migration
  def change
    create_table :scoped_affiliations do |t|
      t.integer :subject_id, null: false
      t.string :value, null: false
      t.string :scope, null: false
      t.timestamp :created_at, null: false
    end
  end
end
