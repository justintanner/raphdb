# frozen_string_literal: true

require "test_helper"

class CleanableTest < ActiveSupport::TestCase
  test "should remove extra whitepsace" do
    cleaned_value = Clean.clean_value("Extra \t\n whitespace")

    assert_equal "Extra whitespace", cleaned_value, "Whitespace was not removed"
  end

  test "should leave dashes alone" do
    cleaned_value = Clean.clean_value("England - Dorset")

    assert_equal "England - Dorset", cleaned_value, "Whitespace was not removed"
  end
end
