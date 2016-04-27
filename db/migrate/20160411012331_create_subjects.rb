class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :mail, null: false
      t.boolean :enabled, null: false
      t.boolean :complete, null: false
      t.timestamps null: false
    end
  end
end
