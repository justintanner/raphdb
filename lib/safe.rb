# frozen_string_literal: true

# Utility methods for getting safe values from user input without exceptions.
module Safe
  def self.date(value)
    Date.parse(value.to_s)
  rescue
    nil
  end

  def self.float(value)
    Float(value.to_s)
  rescue
    nil
  end

  def self.integer(value)
    return value.to_i if value.to_i.to_s == value.to_s
  end
end
