# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "remove whitespace from names" do
    user = User.create!(name: "  John Doe  ", email: "a@b.com", password: "password")

    assert_equal "John Doe", user.name, "Name not stripped of whitespace"
  end

  test "creates initials for a name" do
    user = User.create!(name: "  John Doe  ", email: "a@b.com", password: "password")

    assert_equal "JD", user.name_initials, "Name was not converted to initials"
  end
end
