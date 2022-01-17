class RenameChangelogToLog < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :changelog, :log
    rename_column :item_sets, :changelog, :log
  end
end
