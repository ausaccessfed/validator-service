# frozen_string_literal: true
# Class for migration that changes database collation to utf8_bin
class ChangeDatabaseCollationTobinary < ActiveRecord::Migration
  def change
    # rubocop:disable Rails/ReversibleMigration
    execute('ALTER DATABASE COLLATE = utf8_bin')
    # rubocop:enable Rails/ReversibleMigration
  end
end
