class RemoveFieldsPosition < ActiveRecord::Migration[7.0]
  def change
    remove_column :fields, :position
    add_column :fields, :deleted_at, :datetime
  end
end
