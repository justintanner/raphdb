class CreateItemSets < ActiveRecord::Migration[7.0]
  def change
    create_table :item_sets do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
