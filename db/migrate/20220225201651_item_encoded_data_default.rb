class ItemEncodedDataDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :encoded_data, {}
  end
end
