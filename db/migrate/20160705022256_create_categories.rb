class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :url
      t.boolean :enabled
      t.integer :order

      t.timestamps
    end
  end
end