class PagesChangelog < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :changelog, :jsonb, index: :gin, default: { h: {} }
  end
end
