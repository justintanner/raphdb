# frozen_string_literal: true

require "test_helper"

class SingleSelectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "creates a new single select option" do
    post editor_single_selects_url, params: {single_select: {title: "New Option", field_id: fields(:orientation).id}}
    assert_response :success
  end

  test "returns a json error when given no params" do
    post editor_single_selects_url, params: {single_select: {}}
    assert_response :unprocessable_entity
  end
end
