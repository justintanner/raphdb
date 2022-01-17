class CreateItemImages < ActiveRecord::Migration[7.0]
  def change
    create_table :item_images do |t|
      t.integer :item_id
      t.integer :position, default: 1
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
