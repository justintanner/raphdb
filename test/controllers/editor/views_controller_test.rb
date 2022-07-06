# frozen_string_literal: true

require "test_helper"

class ViewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "renders the default view" do
    get "/editor/views/default"
    assert_response :success
  end

  test "should rename a view" do
    view = views(:default)

    patch "/editor/views/#{view.id}", params: {view: {title: "New Title"}}

    assert_response :success
    assert view.reload.title == "New Title"
  end

  test "should set a view to the be the default" do
    default_view = views(:default)
    view = View.create!(title: "New Default")
    patch "/editor/views/#{view.id}", params: {view: {default: true}}

    assert_response :success
    assert view.reload.default, "View not set to default"
    assert !default_view.reload.default, "Old default view is still default"
  end

  test "should return a json error when a blank title is given" do
    view = views(:default)
    patch "/editor/views/#{view.id}", params: {view: {title: ""}}

    assert_response :unprocessable_entity
    assert_equal "Title can't be blank", response.parsed_body["errors"].first
  end

  test "should soft delete a view" do
    view = View.create!(title: "Deletable View")
    delete "/editor/views/#{view.id}"

    assert_response :redirect
  end

  test "should duplicate a view and redirect to it" do
    default_view = views(:default)
    post "/editor/views/#{default_view.id}/duplicate"

    assert_response :redirect
  end
end
