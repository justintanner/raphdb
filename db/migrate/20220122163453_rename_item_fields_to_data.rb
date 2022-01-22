class RenameItemFieldsToData < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :fields, :data
  end
end
