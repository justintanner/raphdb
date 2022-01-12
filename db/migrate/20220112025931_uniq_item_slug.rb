class UniqItemSlug < ActiveRecord::Migration[7.0]
  def change
    add_index :items, :slug, unique: true
  end
end
