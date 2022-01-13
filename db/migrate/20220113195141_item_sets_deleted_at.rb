class ItemSetsDeletedAt < ActiveRecord::Migration[7.0]
  def change
    add_column :item_sets, :deleted_at, :datetime, index: true
  end
end
