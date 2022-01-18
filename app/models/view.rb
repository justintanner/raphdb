class View < ApplicationRecord
  include Undeletable

  validates :title, presence: true

  before_save :only_one_default

  private

  def only_one_default
    if self.default_changed? && self.default == true
      View.where.not(id: self.id).update_all(default: false)
    end
  end
end
