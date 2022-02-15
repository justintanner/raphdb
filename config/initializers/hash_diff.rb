# frozen_string_literal: true

# Compares two hashes and returns a hash of the differences.
class Hash
  def diff(compare_to)
    reject { |k, v| compare_to[k] == v }
      .merge!(compare_to.reject { |k, _v| key?(k) })
  end
end
