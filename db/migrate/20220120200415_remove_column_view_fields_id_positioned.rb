class RemoveColumnViewFieldsIdPositioned < ActiveRecord::Migration[7.0]
  def change
    remove_column :views, :field_ids_positioned
  end
end
