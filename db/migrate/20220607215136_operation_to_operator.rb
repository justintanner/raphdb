class OperationToOperator < ActiveRecord::Migration[7.0]
  def change
    rename_column :filters, :operation, :operator
  end
end
