class CreateViewFields < ActiveRecord::Migration[7.0]
  def change
    create_table :view_fields do |t|
      t.integer :view_id
      t.integer :field_id
      t.integer :position
      t.timestamps
    end
  end
end
