class FieldsBootstrapColDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :fields, :bootstrap_col, "col-12"
  end
end
