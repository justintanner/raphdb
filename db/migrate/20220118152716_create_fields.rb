class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.string :title
      t.string :key
      t.string :column_type
      t.boolean :permanent, default: false
      t.boolean :publish, default: true
      t.boolean :same_across_set, default: false
      t.boolean :item_identifier, default: false
      t.integer :position

      t.timestamps
    end
  end
end
