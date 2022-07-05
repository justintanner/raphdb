# frozen_string_literal: true

require "test_helper"

class View::PublishedTabsComponentTest < ViewComponent::TestCase
  def test_component_renders_the_images_tab
    view = View.default

    with_request_url "/editor/views/#{view.id}" do
      items = [item_create!(item_title: "Apple"), item_create!(item_title: "Banana")]
      mock_pagy = OpenStruct.new({next: 2, offset: 0, total_count: 100})

      render_inline(View::PublishedTabsComponent.new(view: view, items: items, tab: "images", pagy: mock_pagy, query: nil))

      assert_text("Apple")
    end
  end

  def test_component_renders_the_list_tab
    view = View.default

    with_request_url "/editor/views/#{view.id}" do
      items = [item_create!(item_title: "Apple"), item_create!(item_title: "Banana")]
      mock_pagy = OpenStruct.new({next: 2, offset: 0, total_count: 100})

      render_inline(View::PublishedTabsComponent.new(view: view, items: items, tab: "list", pagy: mock_pagy, query: nil))

      assert_text("Apple")
    end
  end
end
