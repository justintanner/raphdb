class Droppageslug < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :slug
  end
end
