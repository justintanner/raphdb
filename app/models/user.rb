# frozen_string_literal: true

class User < ApplicationRecord
  # Options not used from the devise setup :registerable, :timeoutable, :lockable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :omniauthable,
         :invitable

  def remember_me
    true
  end
end
