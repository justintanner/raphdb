class RemoveLogColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :log
    remove_column :pages, :log
  end
end
