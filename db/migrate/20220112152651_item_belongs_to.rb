class ItemBelongsTo < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :item_set_id, :integer
  end
end
