# frozen_string_literal: true

module ApplicationHelper
  def all_devise_messages(resource, flash)
    return [] if resource.errors.empty? && flash.empty?

    messages = resource.errors.full_messages.map(&:message) + flash.map { |_type, message| message }

    messages.reject { |message| message == I18n.t("devise.failure.unauthenticated") }
  end
end
