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
end
