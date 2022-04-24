require "test_helper"

class Editor::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should update a setting" do
    bob = users(:bob)
    sign_in(bob)

    post editor_settings_path, params: {
      settings: {
        sidebar_open: true
      }
    }

    assert_response :success

    bob.reload
    assert_equal true, bob.settings["sidebar_open"]
  end

  test "should not override existing settings" do
    bob = users(:bob)
    sign_in(bob)

    post editor_settings_path, params: {
      settings: {
        remove_me: true
      }
    }

    bob.reload

    assert_equal false, bob.settings["sidebar_open"]
  end
end
