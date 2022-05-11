require "test_helper"

class Editor::ImagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:bob))
  end

  test "should update the position of an image" do
    image = images(:football_back2)

    patch editor_image_path(image), params: {position: 1}
    assert_response :success

    image.reload
    assert_equal image.position, 1, "Image was not positioned correctly"
  end
end
