# frozen_string_literal: true

require "active_support/concern"

module Positionable
  extend ActiveSupport::Concern

  included do
    before_save do
      if position.nil?
        reposition_all if position_order_corrupt?

        self.position = next_position
      end
    end

    default_scope { order(position: :asc) }
  end

  class_methods do
    def position_within(*cols)
      class_variable_set(:@@position_within_cols, cols.to_a)
    end
  end

  def position_within_cols
    if self.class.class_variables.include?(:@@position_within_cols)
      self.class.class_variable_get(:@@position_within_cols)
    end
  end

  def positionable_where
    if position_within_cols.present?
      position_within_cols
        .select { |col| send(col).present? }
        .map { |col| "#{col} = #{send(col)}" }
        .join(" AND ")
    else
      "TRUE"
    end
  end

  def next_position
    self.class.where(positionable_where).count + 1
  end

  def position_order_corrupt?
    self.class.where(positionable_where).pluck(:position) != 1.upto(next_position - 1).to_a
  end

  def reposition_all
    self.class.where(positionable_where).each.with_index(1) do |model, position|
      model.update!(position: position) if model.position != position
    end
  end

  def move_to(dest_position)
    raise "position_within is not set" if self.class.class_variable_get(:@@position_within_cols).blank?

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
    self.class.execute_sql(
      "UPDATE #{self.class.table_name}
      SET position = position + 1
      WHERE #{positionable_where} AND position >= ? AND position < ?",
      new_position,
      current_position
    )
  end

  def move_position_up(current_position, new_position)
    self.class.execute_sql(
      "UPDATE #{self.class.table_name}
      SET position = position - 1
      WHERE #{positionable_where} AND position > ? AND position <= ?",
      current_position,
      new_position
    )
  end
end
