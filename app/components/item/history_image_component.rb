# frozen_string_literal: true

class Item::HistoryImageComponent < ViewComponent::Base
  include SrcsetHelper

  def initialize(log:)
    @log = log
  end

  def image
    @log.image
  end

  def deleted?
    @log.action == "destroy"
  end

  def uploaded?
    @log.action == "create"
  end

  def restored?
    image.restored_at.present?
  end

  def was_not_restored?
    image.deleted_at.present?
  end
end
