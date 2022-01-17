class NoDefaultForItemImagePosition < ActiveRecord::Migration[7.0]
  def change
    remove_column :item_images, :position
    add_column :item_images, :position, :integer
  end
end
