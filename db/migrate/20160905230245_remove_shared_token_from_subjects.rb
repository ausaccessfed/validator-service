class RemoveSharedTokenFromSubjects < ActiveRecord::Migration[5.0]
  def change
    remove_index :subjects, [:targeted_id, :auedupersonsharedtoken]
    remove_column :subjects, :auedupersonsharedtoken
    add_index :subjects, :targeted_id, unique: true
  end
end
