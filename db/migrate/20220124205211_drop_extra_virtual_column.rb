class DropExtraVirtualColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :virtual
  end
end
