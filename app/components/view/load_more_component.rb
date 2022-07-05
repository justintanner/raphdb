# frozen_string_literal: true

class View::LoadMoreComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(tab:, query:, next_page: nil)
    @tab = tab
    @query = query
    @next_page = next_page
  end
end
