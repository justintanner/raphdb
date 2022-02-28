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
end
