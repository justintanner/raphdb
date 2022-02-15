# frozen_string_literal: true

class RemoveItemSetUniqIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :item_sets, name: :index_item_sets_on_title
  end
end
