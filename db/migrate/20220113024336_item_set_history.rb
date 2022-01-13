class ItemSetHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :item_sets, :history, :jsonb, default: { h: [] }
    add_index :item_sets, :history, using: :gin
  end
end
