# frozen_string_literal: true

class AddFieldsCurrency < ActiveRecord::Migration[7.0]
  def change
    remove_column :fields, :currency_symbol

    add_column :fields, :currency, :string
  end
end
