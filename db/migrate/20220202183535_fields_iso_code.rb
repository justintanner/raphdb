# frozen_string_literal: true

class FieldsIsoCode < ActiveRecord::Migration[7.0]
  def change
    rename_column :fields, :currency, :currency_iso_code
  end
end
