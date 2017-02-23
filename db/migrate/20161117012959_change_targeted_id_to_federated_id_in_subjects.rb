# frozen_string_literal: true
class ChangeTargetedIdToFederatedIdInSubjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :subjects, :targeted_id, :federated_id
  end
end
