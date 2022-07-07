# frozen_string_literal: true

require "test_helper"

class View::EditableListComponentTest < ViewComponent::TestCase
  def test_component_renders_editable_list_with_no_items
    view = View.published

    with_request_url "/editor/views/#{view.id}" do
      mock_pagy = OpenStruct.new({next: 2, offset: 0, count: 100})
      render_inline(View::EditableListComponent.new(view: view, items: [], query: "Apples", pagy: mock_pagy))

      assert_selector("#editable_list", count: 1)
    end
  end
end
