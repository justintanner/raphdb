class ItemsRestoreData < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :encoded_data, :data
    add_column :items, :search_data, :text

    remove_column :items, :search_tsvector_col

    add_column :items,
      :search_tsvector_col,
      :virtual,
      type: :tsvector, as: "to_tsvector('english', search_data)", stored: true
  end
end
