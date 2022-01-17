class RenameItemImagesToImages < ActiveRecord::Migration[7.0]
  def change
    rename_table :item_images, :images
  end
end
