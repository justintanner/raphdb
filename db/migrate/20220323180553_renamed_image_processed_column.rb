class RenamedImageProcessedColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :images, :processed
    add_column :images, :processed_at, :datetime
  end
end
