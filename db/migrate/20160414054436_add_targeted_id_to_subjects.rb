class AddTargetedIdToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :targeted_id, :string
  end
end
