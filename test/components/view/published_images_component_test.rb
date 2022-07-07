# frozen_string_literal: true

require "test_helper"

class View::PublishedImagesComponentTest < ViewComponent::TestCase
  def test_component_renders_two_items
    view = View.published

    with_request_url "/editor/views/#{view.id}" do
      items = [item_create!(item_title: "Apple"), item_create!(item_title: "Banana")]
      mock_pagy = OpenStruct.new({next: 2, offset: 0, total_count: 100})

      render_inline(View::PublishedImagesComponent.new(view: view, items: items, query: nil, pagy: mock_pagy))

      assert_text("Apple")
      assert_text("Banana")
    end
  end
end
