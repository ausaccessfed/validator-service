class SubjectTargetedIdAndToken < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :auedupersonsharedtoken, :string, null: false

    add_index :subjects, [:targeted_id, :auedupersonsharedtoken], unique: true
  end
end