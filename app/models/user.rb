# frozen_string_literal: true

class User < ApplicationRecord
  include Cleanable
  # Options not used from the devise setup :registerable, :timeoutable, :confirmable, :lockable
  devise :database_authenticatable,
    :recoverable,
    :rememberable,
    :validatable,
    :trackable,
    :omniauthable,
    :invitable

  clean :name

  before_save :no_boolean_strings

  validates :name, presence: true

  def remember_me
    true
  end

  def name_initials
    name
      .split(/[[:space:]]+/)
      .map(&:first)
      .join
  end

  private

  def no_boolean_strings
    settings.each do |key, value|
      if value == "false"
        settings[key] = false
      elsif value == "true"
        settings[key] = true
      end
    end
  end
end
