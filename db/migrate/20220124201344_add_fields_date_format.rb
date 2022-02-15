# frozen_string_literal: true

class AddFieldsDateFormat < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :date_format, :string
  end
end
