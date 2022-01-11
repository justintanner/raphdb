class Readdslug < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :slug, :string, index: true
  end
end
