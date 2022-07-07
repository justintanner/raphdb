# frozen_string_literal: true

require "test_helper"

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "redirects to login page when not logged in" do
    get "/editor"
    assert_response :redirect
  end

  test "renders the published view when logged in" do
    sign_in(users(:bob))

    get "/editor"
    assert_response :success
  end
end
