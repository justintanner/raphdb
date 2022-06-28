class FilterUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :filters, :uuid, :string
  end
end
