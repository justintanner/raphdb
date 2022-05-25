require "application_system_test_case"

class EditorImagesTest < ApplicationSystemTestCase
  setup do
    sign_in(users(:bob))
  end

  test "uploading an image" do
    visit default_editor_views_path

    click_on "Edit Item", match: :first

    assert_selector "h5", text: "Editing Item"

    attach_file("image[files][]", file_fixture("vertical.jpg"), visible: false)

    assert_selector ".spinner-border", count: 1

    # Image upload is not finishing even with Capybara.default_max_wait_time = 10
    assert_content "Adjust"
    assert_content "Delete"
  end
end
