class ImageProcessedFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :processed, :boolean, default: false
  end
end
