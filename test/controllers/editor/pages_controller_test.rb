# frozen_string_literal: true

require "test_helper"

class Editor::PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:bob))
  end

  test "can edit the homepage page" do
    get edit_editor_page_path(pages(:homepage))
    assert_response :success
  end

  test "can update the homepage page" do
    patch editor_page_path(pages(:homepage)), params: {page: {body: "New content"}}
    assert_response :redirect
  end
end
