class SortsUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :sorts, :uuid, :string
  end
end
