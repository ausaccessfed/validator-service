class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.string :value, null: false
      t.integer :aaf_attribute_id
      t.timestamps null: false
    end
  end
end
