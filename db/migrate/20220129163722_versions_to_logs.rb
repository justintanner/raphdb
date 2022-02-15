# frozen_string_literal: true

class VersionsToLogs < ActiveRecord::Migration[7.0]
  def change
    rename_table :versions, :logs
    rename_column :logs, :data, :entry
  end
end
