class AddItemSetIdToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :item_set_id, :integer
  end
end
