class CreateSingleSelects < ActiveRecord::Migration[7.0]
  def change
    create_table :single_selects do |t|
      t.references :field
      t.string :title

      t.timestamps
    end
  end
end
