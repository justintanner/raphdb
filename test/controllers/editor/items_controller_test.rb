require "test_helper"

class Editor::ItemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:bob))
  end

  test "edits an item inside its offcanvas" do
    item = items(:football)

    get edit_editor_item_path(item.id)
    assert_response :success
  end

  test "updates an item" do
    item = items(:football)

    patch editor_item_path(item.id), params: {item: {data: {item_title: "Zebra"}}}
    assert_response :success
    assert_equal item.reload.title, "Zebra", "Item was not updated"
  end

  test "updates an item with an xhr" do
    item = items(:football)

    patch editor_item_path(item.id, format: :json), params: {item: {data: {item_title: "Zebra"}}}
    assert_response :success
    assert_equal item.reload.title, "Zebra", "Item was not updated"
  end

  test "new item" do
    get new_editor_item_path
    assert_response :success
  end

  test "creates an item" do
    item_set = item_sets(:empty_set)

    post editor_items_path, params: {item: {data: {item_title: "Apple"}, item_set_id: item_set.id}}
    assert_response :success
    assert_equal item_set.reload.items.map { |item| item.data["item_title"] }, ["Apple"], "Item was not created"
  end

  test "creates an item with an xhr" do
    item_set = item_sets(:empty_set)

    post editor_items_path(format: :json), params: {item: {data: {item_title: "Apple"}, item_set_id: item_set.id}}
    assert_response :success
    assert_equal item_set.reload.items.map { |item| item.data["item_title"] }, ["Apple"], "Item was not created"
  end
end
