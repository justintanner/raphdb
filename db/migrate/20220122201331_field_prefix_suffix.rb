class FieldPrefixSuffix < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :prefix_field_id, :integer, references: :field
    add_column :fields, :suffix_field_id, :integer, references: :field
  end
end
