# frozen_string_literal: true

require "test_helper"

class View::RefreshListComponentTest < ViewComponent::TestCase
  def test_component_renders_a_form_to_refresh_the_list
    render_inline(View::RefreshListComponent.new(view: View.published))

    assert_selector("#refresh_list")
    assert_selector("span.spinner-border")
  end
end
