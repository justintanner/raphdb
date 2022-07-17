# frozen_string_literal: true

class Item::HistoryCardComponent < ViewComponent::Base
  with_collection_parameter :log

  def initialize(log:, log_iteration: nil)
    @log = log
    @log_iteration = log_iteration
  end
end
