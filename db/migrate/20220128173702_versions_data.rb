# frozen_string_literal: true

class VersionsData < ActiveRecord::Migration[7.0]
  def change
    rename_column :versions, :changes, :data
  end
end
