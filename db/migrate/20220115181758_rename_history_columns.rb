class RenameHistoryColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :history, :changelog
    rename_column :item_sets, :history, :changelog
  end
end
