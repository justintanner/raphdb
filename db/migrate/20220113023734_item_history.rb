class ItemHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :history, :jsonb, default: { h: [] }
    add_index :items, :history, using: :gin
  end
end
