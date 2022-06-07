require "application_system_test_case"

class EditorSortsTest < ApplicationSystemTestCase
  setup do
    sign_in(users(:bob))
  end

  def delete_sort(name)
    assert_select "view_sorts_field_id", selected: name
    click_on "delete-sort", match: :first
    assert_no_select "view_sorts_field_id", selected: name
  end

  test "sorting the default view" do
    visit default_editor_views_path

    click_on "Sort"

    within ".dropdown-menu" do
      assert_content "Sort by"
      assert_content "then by"

      delete_sort("Set Title")
      delete_sort("Prefix")
      delete_sort("Number")
      delete_sort("In set")
      delete_sort("Item Title")

      select "Number", from: "pick_another_field"
      assert_select "view_sorts_field_id", selected: "Number"

      click_on "Apply"
    end
  end
end
