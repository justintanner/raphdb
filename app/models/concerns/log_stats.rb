require 'active_support/concern'

module LogStats
  extend ActiveSupport::Concern

  class_methods do
    def with_mismatching_data_to_logs
      all.select { |object| !object.logs_match_current_data? }
    end
  end

  def logs_match_current_data?
    data_log_diff == {}
  end

  def data_log_diff
    a =
      self
        .data
        .except(*Field::RESERVED_KEYS)
        .reject { |_k, v| v.nil? || v == false || v == [] }

    b =
      Log
        .rebuild_data_from_logs(self)
        .reject { |_k, v| v.nil? || v == false || v == [] }

    a.diff(b)
  end

  def total_log_images
    created = logs.count { |log| log.associated_type == 'Image' && log.action == 'create' }
    destroyed = logs.count { |log| log.associated_type == 'Image' && log.action == 'destroy' }

    created - destroyed
  end
end
