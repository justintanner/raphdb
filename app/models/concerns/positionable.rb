# frozen_string_literal: true

require "active_support/concern"

module Positionable
  extend ActiveSupport::Concern

  included do
    before_save do
      self.position ||= next_position
    end

    after_save do
      reposition_all if position_order_corrupt?
    end

    after_destroy do
      reposition_all
    end

    default_scope { order(position: :asc) }
  end

  class_methods do
    def position_within(*models)
      class_variable_set(:@@positionable_within, models.to_a)
    end
  end

  def positionable_within
    if self.class.class_variables.include?(:@@positionable_within)
      self.class.class_variable_get(:@@positionable_within)
    end
  end

  def positionable_parent
    return unless positionable_within.present?

    first_parent = positionable_within.find { |model| self["#{model}_id"].present? }

    send(first_parent)
  end

  def positionable_objects
    if positionable_parent.present?
      positionable_parent.send(self.class.to_s.underscore.pluralize)
    else
      self.class.all
    end
  end

  def next_position
    positionable_objects.count + 1
  end

  def position_order_corrupt?
    positionable_objects.pluck(:position) != 1.upto(next_position - 1).to_a
  end

  def reposition_all
    positionable_objects.each.with_index(1) do |object, position|
      object.update!(position: position) if object.position != position
    end
  end

  def move_to(dest_position)
    new_position = [[dest_position, 1].max, next_position].min
    current_position = position

    return if new_position == current_position

    if current_position.nil? || new_position > current_position
      move_position_up(current_position, new_position)
    elsif new_position < current_position
      move_position_down(current_position, new_position)
    end

    update(position: new_position)
  end

  private

  def move_position_down(current_position, new_position)
    positionable_objects
      .where("position >= ? AND position < ?", new_position, current_position)
      .update_all("position = position + 1")
  end

  def move_position_up(current_position, new_position)
    positionable_objects
      .where("position > ? AND position <= ?", current_position, new_position)
      .update_all("position = position - 1")
  end
end
