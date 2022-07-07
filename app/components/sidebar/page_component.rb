# frozen_string_literal: true

class Sidebar::PageComponent < ViewComponent::Base
  with_collection_parameter :page

  def initialize(page:, page_iteration: nil, current_page: nil)
    @page = page
    @page_iteration = page_iteration
    @current_page = current_page
  end

  def active?
    @page == @current_page
  end
end
