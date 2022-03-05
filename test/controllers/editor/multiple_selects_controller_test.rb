# frozen_string_literal: true

require "test_helper"

class MultipleSelectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:bob))
  end

  test "creates a new multiple select option" do
    post editor_multiple_selects_url, params: {multiple_select: {title: "New Option", field_id: fields(:orientation).id}}
    assert_response :success
  end

  test "returns a json error when given no params" do
    post editor_multiple_selects_url, params: {multiple_select: {}}
    assert_response :unprocessable_entity
  end
end
