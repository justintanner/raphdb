class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views do |t|
      t.string :title
      t.boolean :default, default: false
      t.string :fields_position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
