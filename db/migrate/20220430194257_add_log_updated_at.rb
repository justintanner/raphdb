class AddLogUpdatedAt < ActiveRecord::Migration[7.0]
  def change
    add_column :logs, :updated_at, :datetime
  end
end
