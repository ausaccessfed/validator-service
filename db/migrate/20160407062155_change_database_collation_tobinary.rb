# frozen_string_literal: true

# Class for migration that changes database collation to utf8_bin
class ChangeDatabaseCollationTobinary < ActiveRecord::Migration[4.2]
  def change
    execute('ALTER DATABASE COLLATE = utf8_bin')
  end
end
