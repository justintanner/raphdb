class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.execute_sql(*sql_array)
    connection.execute(sanitize_sql_array(sql_array))
  end
end
