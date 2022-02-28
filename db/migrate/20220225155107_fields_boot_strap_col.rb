class FieldsBootStrapCol < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :bootstrap_col, :string
  end
end
