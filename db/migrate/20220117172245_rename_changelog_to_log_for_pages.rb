class RenameChangelogToLogForPages < ActiveRecord::Migration[7.0]
  def change
    rename_column :pages, :changelog, :log
  end
end
