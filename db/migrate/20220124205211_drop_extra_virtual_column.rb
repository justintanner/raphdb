class DropExtraVirtualColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :data_tsvector_col

    add_column :items,
               :data_tsvector_col,
               :virtual,
               type: :tsvector,
               as: "to_tsvector('english'::regconfig, regexp_replace(data::text, '([^a-z0-9]+)', '\\1 ', 'gi')::jsonb)",
               stored: true
  end
end
