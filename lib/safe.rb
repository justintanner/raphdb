# frozen_string_literal: true

# Utility methods for getting safe values from user input without exceptions.
module Safe
  def self.date(value)
    Date.parse(value) rescue nil
  end

  def self.float(value)
    Float(value) rescue nil
  end

  def self.integer(value)
    return value if value.to_i.to_s == value.to_s
  end
end
