# frozen_string_literal: true

require "test_helper"

class Set::LinkComponentTest < ViewComponent::TestCase
  def test_component_renders_a_link_to_the_set
    render_inline(Set::LinkComponent.new(item_set: item_sets(:orphan)))

    assert_selector("a", text: "Orphan")
  end
end
