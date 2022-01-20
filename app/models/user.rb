class User < ApplicationRecord
  # Options not used from the devise setup :registerable, :timeoutable, :lockable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable,
         :omniauthable,
         :invitable
end
