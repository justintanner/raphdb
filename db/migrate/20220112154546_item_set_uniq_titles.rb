class ItemSetUniqTitles < ActiveRecord::Migration[7.0]
  def change
    add_index :item_sets, :title, unique: true
  end
end
