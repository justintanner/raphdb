class ImageRestoredAt < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :restored_at, :datetime
  end
end
