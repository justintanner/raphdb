class FieldsDivider < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :divider, :boolean, default: false
  end
end
