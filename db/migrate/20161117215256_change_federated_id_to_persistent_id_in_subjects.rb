# frozen_string_literal: true
class ChangeFederatedIdToPersistentIdInSubjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :subjects, :federated_id, :persistent_id
  end
end
