# frozen_string_literal: true

class FieldNumberFormat < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :number_format, :string, default: "Integer (2)"
  end
end
