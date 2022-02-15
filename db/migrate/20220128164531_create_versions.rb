# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.column :model_id, :bigint
      t.column :model_type, :string
      t.column :associated_id, :bigint
      t.column :associated_type, :string
      t.column :user_id, :bigint
      t.column :action, :string
      t.column :changes, :jsonb
      t.column :version, :integer, default: 0
      t.column :created_at, :datetime
    end

    add_index :versions, %i[model_type model_id version]
    add_index :versions, %i[associated_type associated_id]
    add_index :versions, :user_id
    add_index :versions, :created_at
    add_index :versions, :changes, using: :gin
  end
end
