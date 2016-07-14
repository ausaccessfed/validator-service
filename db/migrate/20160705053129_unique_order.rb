class UniqueOrder < ActiveRecord::Migration[5.0]
  def change
    add_index :categories, :order, unique: true
  end
end
