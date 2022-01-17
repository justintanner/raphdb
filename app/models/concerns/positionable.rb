# frozen_string_literal: true
require 'active_support/concern'

# Will only work for Items and ItemSets
module Positionable
  extend ActiveSupport::Concern

  included do
    before_save { self.position ||= self.next_position }

    default_scope { order(position: :asc) }
  end

  def next_position
    if self.item.present?
      self.class.where(item_id: self.item_id).count + 1
    elsif self.item_set.present?
      self.class.where(item_set_id: self.item_set_id).count + 1
    end
  end

  def move_to(position_arg)
    return if self.item.nil? && self.item_set.nil?

    new_position = [[position_arg, 1].max, self.next_position].min
    current_position = self.position

    return if new_position == current_position

    belong_to_col = nil
    belong_to_id = nil

    if item.present?
      belong_to_col = 'item_id'
      belong_to_id = self.item_id
    elsif item_set.present?
      belong_to_col = 'item_set_id'
      belong_to_id = self.item_set_id
    end

    if current_position.nil? || new_position > current_position
      self.class.execute_sql(
        "
      UPDATE #{self.class.table_name}
      SET position = position - 1
      WHERE #{belong_to_col} = ? AND position > ? AND position <= ?",
        belong_to_id,
        current_position,
        new_position
      )
    elsif new_position < current_position
      self.class.execute_sql(
        "
      UPDATE #{self.class.table_name}
      SET position = position + 1
      WHERE #{belong_to_col} = ? AND position >= ? AND position < ?",
        belong_to_id,
        new_position,
        current_position
      )
    end

    self.update(position: new_position)
  end
end
