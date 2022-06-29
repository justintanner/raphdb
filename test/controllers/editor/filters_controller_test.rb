# frozen_string_literal: true

require "test_helper"

class FiltersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "injects a new filter" do
    view = views(:default)
    get "/editor/views/#{view.id}/filters/new"
    assert_response :success
  end

  test "creates a new filter" do
    view = views(:default)
    post "/editor/views/#{view.id}/filters", params: {filter: {field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob"}}
    assert_response :success
  end

  test "returns unprocessable entity when creating with incomplete data" do
    view = views(:default)
    post "/editor/views/#{view.id}/filters", params: {filter: {field_id: fields(:artist).id, view_id: view.id}}
    assert_response :unprocessable_entity
  end

  test "creates a new filter with a json response" do
    view = views(:default)
    post "/editor/views/#{view.id}/filters.json", params: {filter: {field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob"}}
    assert_response :success
  end

  test "returns unprocessable entity when creating with incomplete data when given a json request" do
    view = views(:default)
    post "/editor/views/#{view.id}/filters.json", params: {filter: {field_id: fields(:artist).id, view_id: view.id}}
    assert_response :unprocessable_entity
  end

  test "edits an existing filter" do
    view = views(:default)
    filter = Filter.create!(field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob")

    get "/editor/filters/#{filter.id}/edit"
    assert_response :success
  end

  test "updates an existing filter" do
    view = views(:default)
    filter = Filter.create!(field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob")

    patch "/editor/filters/#{filter.id}", params: {filter: {field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Alice"}}
    assert_response :success
    assert_equal "Alice", filter.reload.value, "Filter was not updated"
  end

  test "updates an existing filter via json" do
    view = views(:default)
    filter = Filter.create!(field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob")

    patch "/editor/filters/#{filter.id}.json", params: {filter: {field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Alice"}}
    assert_response :success
    assert_equal "Alice", filter.reload.value, "Filter was not updated"
  end

  test "destroys a filter based on it's uuid, not id" do
    view = views(:default)
    filter = Filter.create!(field_id: fields(:artist).id, view_id: view.id, operator: "is", value: "Bob")

    delete "/editor/views/#{view.id}/filters/destroy_by_uuid", params: {uuid: filter.uuid}
    assert_response :success
    assert Filter.find_by(uuid: filter.uuid).nil?, "Filter was not deleted"
  end
end
