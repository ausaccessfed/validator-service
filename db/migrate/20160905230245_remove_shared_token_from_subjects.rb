# frozen_string_literal: true

class RemoveSharedTokenFromSubjects < ActiveRecord::Migration[5.0]
  def change
    remove_index :subjects, %i[targeted_id auedupersonsharedtoken]
    remove_column :subjects, :auedupersonsharedtoken, :string
    add_index :subjects, :targeted_id, unique: true
  end
end
