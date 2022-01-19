class View < ApplicationRecord
  include Undeletable
  has_many :sorts

  validates :title, presence: true

  before_save :only_one_default

  def sql_sort_order
    sorts.map { |sort| sort.to_sql }.join(', ')
  end

  def self.default
    find_by(default: true)
  end

  private

  def only_one_default
    if self.default_changed? && self.default == true
      View.where.not(id: self.id).update_all(default: false)
    end
  end
end
