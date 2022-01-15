class PagesChangelogFix < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :changelog
    add_column :pages, :changelog, :jsonb, index: :gin
  end
end
