class Filters < ActiveRecord::Migration[7.0]
  def change
    create_table :filters, force: :cascade do |t|
      t.references :view, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.string :operation
      t.string :value
      t.integer :position
      t.timestamps
    end
  end
end
