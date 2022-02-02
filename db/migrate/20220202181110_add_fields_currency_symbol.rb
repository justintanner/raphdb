class AddFieldsCurrencySymbol < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :currency_symbol, :string, default: '$'
  end
end
