# frozen_string_literal: true
require 'active_support/concern'

module Positionable
  extend ActiveSupport::Concern

  included do
    before_save { self.position ||= self.next_position }

    default_scope { order(position: :asc) }
  end

  class_methods do
    def position_within(*cols)
      self.class_variable_set(:@@position_within_cols, cols.to_a)
    end
  end

  def position_group_where
    position_within_cols =
      self.class.class_variable_get(:@@position_within_cols)
    raise 'position_within is not set' if position_within_cols.blank?

    position_within_cols
      .select { |col| self.send(col).present? }
      .map { |col| "#{col} = #{self.send(col)}" }
      .join(' AND ')
  end

  def next_position
    self.class.where(self.position_group_where).count + 1
  end

  def move_to(position_arg)
    if self.class.class_variable_get(:@@position_within_cols).blank?
      raise 'position_within is not set'
    end

    new_position = [[position_arg, 1].max, self.next_position].min
    current_position = self.position

    return if new_position == current_position

    if current_position.nil? || new_position > current_position
      self.class.execute_sql(
        "
      UPDATE #{self.class.table_name}
      SET position = position - 1
      WHERE #{self.position_group_where} AND position > ? AND position <= ?",
        current_position,
        new_position
      )
    elsif new_position < current_position
      self.class.execute_sql(
        "
      UPDATE #{self.class.table_name}
      SET position = position + 1
      WHERE #{self.position_group_where} AND position >= ? AND position < ?",
        new_position,
        current_position
      )
    end

    self.update(position: new_position)
  end
end
