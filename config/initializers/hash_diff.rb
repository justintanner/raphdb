# frozen_string_literal: true

class Hash
  def diff(compare_to)
    reject { |k, v| compare_to[k] == v }
      .merge!(compare_to.reject { |k, _v| key?(k) })
  end
end
