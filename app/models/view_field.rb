class ViewField < ApplicationRecord
  include Positionable

  belongs_to :view
  belongs_to :field

  validates :view, :field, presence: true

  position_grouped_by :view_id
end
