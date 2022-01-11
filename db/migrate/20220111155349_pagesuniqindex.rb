class Pagesuniqindex < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :slug, unique: true
  end
end
