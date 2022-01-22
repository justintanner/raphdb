class RenameFieldsTsvectorCol < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :fields_tsvector_col, :data_tsvector_col
  end
end
