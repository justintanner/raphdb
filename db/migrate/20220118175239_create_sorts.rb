class CreateSorts < ActiveRecord::Migration[7.0]
  def change
    create_table :sorts do |t|
      t.integer :view_id
      t.string :attr
      t.string :inner_attr
      t.string :direction
      t.integer :position

      t.timestamps
    end
  end
end
