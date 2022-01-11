class Itemginandvector < ActiveRecord::Migration[7.0]
  def change
    add_index :items, :deleted_at

    add_index :items, :fields, using: :gin

    add_column :items,
               :fields_tsvector_col,
               :virtual,
               type: :tsvector,
               as: "to_tsvector('english', fields)",
               stored: true
  end
end
