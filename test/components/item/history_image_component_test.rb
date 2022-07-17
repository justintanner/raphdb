# frozen_string_literal: true

require "test_helper"

class Item::HistoryImageComponentTest < ViewComponent::TestCase
  def test_component_renders_history_of_images_uploads
    item = items(:football)
    image_create!(filename: "vertical.jpg", item: item, process: true)

    render_inline(Item::HistoryImageComponent.new(log: item.logs.first))

    assert_text "Uploaded Image"
  end

  def test_component_renders_history_of_images_deletions
    item = items(:football)
    image = image_create!(filename: "vertical.jpg", item: item, process: true)
    image.destroy

    render_inline(Item::HistoryImageComponent.new(log: item.logs.first))

    assert_text "Deleted Image"
    assert_text "Restore Image"
  end

  def test_component_renders_history_of_images_restores
    item = items(:football)
    image = image_create!(filename: "vertical.jpg", item: item, process: true)
    image.destroy
    image.restore

    render_inline(Item::HistoryImageComponent.new(log: item.logs.first))

    assert_text "Restored Image"
    assert_no_text "Restore Image"
  end
end
