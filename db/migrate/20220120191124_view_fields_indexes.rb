class ViewFieldsIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :view_fields, :view_id
    add_index :view_fields, :field_id
    add_index :view_fields, :position
  end
end
