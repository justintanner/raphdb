class UniqueSelects < ActiveRecord::Migration[7.0]
  def change
    change_column :single_selects, :title, :string, unique: true
    change_column :multiple_selects, :title, :string, unique: true
  end
end
