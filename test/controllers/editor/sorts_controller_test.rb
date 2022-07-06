require "test_helper"

class Editor::SortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "injects a new sort" do
    view = views(:with_no_filters_or_sorts)
    get "/editor/views/#{view.id}/sorts/new"
    assert_response :success
  end

  test "creates a new sort" do
    view = views(:with_no_filters_or_sorts)
    post "/editor/views/#{view.id}/sorts", params: {sort: {field_id: fields(:artist).id, view_id: view.id, direction: "DESC", position: 1}}
    assert_response :success
  end

  test "returns unprocessable entity when creating with incomplete data" do
    view = views(:with_no_filters_or_sorts)
    post "/editor/views/#{view.id}/sorts", params: {sort: {view_id: view.id}}
    assert_response :unprocessable_entity
  end

  test "edits an existing sort" do
    view = views(:with_no_filters_or_sorts)
    sort = Sort.create!(field_id: fields(:artist).id, view_id: view.id, direction: "DESC", position: 1)

    get "/editor/sorts/#{sort.id}/edit"
    assert_response :success
  end

  test "updates an existing sort" do
    view = views(:with_no_filters_or_sorts)
    sort = Sort.create!(field_id: fields(:artist).id, view_id: view.id, direction: "DESC", position: 1)

    patch "/editor/sorts/#{sort.id}", params: {sort: {field_id: fields(:artist).id, view_id: view.id, direction: "ASC", position: 1}}
    assert_response :success
    assert_equal "ASC", sort.reload.direction, "Sort direction was not updated"
  end

  test "destroys a filter based on it's uuid, not id" do
    view = views(:with_no_filters_or_sorts)
    sort = Sort.create!(field_id: fields(:artist).id, view_id: view.id, direction: "DESC", position: 1)

    delete "/editor/views/#{view.id}/sorts/destroy_by_uuid", params: {sort: {uuid: sort.uuid}}
    assert_response :success
    assert Sort.find_by(uuid: sort.uuid).nil?, "Sort was not deleted"
  end

  test "reorders a filter" do
    view = views(:with_no_filters_or_sorts)
    first_sort = Sort.create!(field_id: fields(:artist).id, view_id: view.id, direction: "DESC", position: 1)
    second_sort = Sort.create!(field_id: fields(:number).id, view_id: view.id, direction: "ASC", position: 2)

    patch "/editor/views/#{view.id}/sorts/reorder_by_uuid", params: {sort: {uuid: second_sort.uuid, position: 1}}
    assert_response :success
    assert_equal 2, first_sort.reload.position, "First sort was not moved to position 1"
    assert_equal 1, second_sort.reload.position, "Second sort was not moved to position 2"
  end
end
