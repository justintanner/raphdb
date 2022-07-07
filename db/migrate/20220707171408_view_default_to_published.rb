class ViewDefaultToPublished < ActiveRecord::Migration[7.0]
  def change
    rename_column :views, :default, :published
  end
end
