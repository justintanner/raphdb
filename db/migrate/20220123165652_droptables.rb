class Droptables < ActiveRecord::Migration[7.0]
  def change
    drop_table :fields
    drop_table :friendly_id_slugs
    drop_table :images
    drop_table :item_sets
    drop_table :items
    drop_table :multiple_selects
    drop_table :pages
    drop_table :single_selects
    drop_table :sorts
    drop_table :users
    drop_table :view_fields
    drop_table :views
  end
end
