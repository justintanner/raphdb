# frozen_string_literal: true

require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should render an item set given its slug" do
    get "/sets/#{item_sets(:early_days_of_sport).slug}"
    assert_response :success
  end
end
