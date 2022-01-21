class FixSelectUniqueness < ActiveRecord::Migration[7.0]
  def change
    change_column :multiple_selects, :title, :string
    change_column :single_selects, :title, :string

    add_index :multiple_selects, [:field_id, :title], unique: true
    add_index :single_selects, [:field_id, :title], unique: true
  end
end
