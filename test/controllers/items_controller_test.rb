# frozen_string_literal: true

require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should render without a search query" do
    get items_path
    assert_response :success
  end
end
