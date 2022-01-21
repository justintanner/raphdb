class CreateMultipleSelects < ActiveRecord::Migration[7.0]
  def change
    create_table :multiple_selects do |t|
      t.references :field
      t.string :title

      t.timestamps
    end
  end
end
