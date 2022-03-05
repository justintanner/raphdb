class AddFieldPosition < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :position, :integer

    change_column_default :fields, :number_format, nil
  end
end
