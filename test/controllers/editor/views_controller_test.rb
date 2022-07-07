# frozen_string_literal: true

require "test_helper"

class ViewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "renders the published view" do
    get "/editor/views/published"
    assert_response :success
  end

  test "should rename a view" do
    view = views(:published)

    patch "/editor/views/#{view.id}", params: {view: {title: "New Title"}}

    assert_response :success
    assert view.reload.title == "New Title"
  end

  test "should return a json error when a blank title is given" do
    view = views(:published)
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
    default_view = views(:published)
    post "/editor/views/#{default_view.id}/duplicate"

    assert_response :redirect
  end
end
