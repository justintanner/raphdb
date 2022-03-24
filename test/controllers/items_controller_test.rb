# frozen_string_literal: true

require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should render items page without a search query" do
    get items_path
    assert_response :success
  end

  test "should render the item page by id" do
    get "/items/#{items(:football).id}"
    assert_response :success
  end

  test "should render the item page by slug" do
    get "/items/#{items(:football).slug}"
    assert_response :success
  end

  test "should render the item page with a different featured picture" do
    process_images_for(item: items(:football))

    get picture_item_path(items(:football).id, 2)
    assert_response :success
  end

  test "should render 404 when a picture number is out of range" do
    assert_raises(ActionController::RoutingError) do
      get picture_item_path(items(:football).id, 9001)
    end
  end
end
