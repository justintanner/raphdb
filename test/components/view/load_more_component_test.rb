# frozen_string_literal: true

require "test_helper"

class View::LoadMoreComponentTest < ViewComponent::TestCase
  def test_component_renders_a_load_more_link_for_lists
    view = View.published

    with_request_url "/editor/views/#{view.id}" do
      render_inline(View::LoadMoreComponent.new(tab: "list", query: "Apples", next_page: 2))

      assert_selector("a#load-more-button")
      assert_selector("span.spinner-border", count: 0)
    end
  end

  def test_component_renders_a_load_more_link_for_images
    view = View.published

    with_request_url "/editor/views/#{view.id}" do
      render_inline(View::LoadMoreComponent.new(tab: "images", query: "Apples", next_page: 2))

      assert_selector("a#load-more-button")
      assert_selector("span.spinner-border")
    end
  end
end
