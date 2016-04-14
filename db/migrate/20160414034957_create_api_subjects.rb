class CreateAPISubjects < ActiveRecord::Migration
  def change
    create_table :api_subjects do |t|
      t.string :x509_cn, null: false
      t.text :description, null: false
      t.string :contact_name, null: false
      t.string :contact_mail, null: false
      t.boolean :enabled, null: false
      t.timestamps null: false
    end
  end
end
