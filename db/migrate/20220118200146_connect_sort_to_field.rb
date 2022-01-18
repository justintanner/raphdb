class ConnectSortToField < ActiveRecord::Migration[7.0]
  def change
    remove_column :sorts, :attr
    remove_column :sorts, :inner_attr
    add_column :sorts, :field_id, :integer
  end
end
