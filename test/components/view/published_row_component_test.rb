# frozen_string_literal: true

require "test_helper"

class View::PublishedRowComponentTest < ViewComponent::TestCase
  def test_component_renders_a_row_of_the_list_table
    view = View.published

    with_request_url "/editor/views/#{view.id}" do
      item = item_create!(item_title: "Apple")
      render_inline(View::PublishedRowComponent.new(item: item, view: view))

      assert_text("Apple")
    end
  end
end
