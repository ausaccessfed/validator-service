# frozen_string_literal: true

class SubjectTargetedIdAndToken < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :auedupersonsharedtoken, :string, null: false, default: ''

    add_index :subjects, %i[targeted_id auedupersonsharedtoken], unique: true
  end
end
