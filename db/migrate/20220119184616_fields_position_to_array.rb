class FieldsPositionToArray < ActiveRecord::Migration[7.0]
  def change
    remove_column :views, :fields_position
    add_column :views, :field_ids_positioned, :integer, array: true
  end
end
