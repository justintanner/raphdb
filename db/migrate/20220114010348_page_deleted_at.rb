class PageDeletedAt < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :deleted_at, :datetime, index: true
  end
end
