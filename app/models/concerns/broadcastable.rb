# frozen_string_literal: true

require "active_support/concern"

module Broadcastable
  extend ActiveSupport::Concern

  def editor_replace_to(target:, component:, locals: {})
    broadcast_replace_to("editor_stream", target: target, html: render_component(component, locals))
  end

  def render_component(component, locals)
    ApplicationController.render(
      component.new(**locals),
      layout: false
    )
  end
end
