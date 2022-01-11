class Removeitemtitle < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :title
  end
end
