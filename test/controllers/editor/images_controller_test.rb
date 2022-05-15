require "test_helper"

class Editor::ImagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:bob))
  end

  test "should upload a new image to an item" do
    item = items(:football)

    post editor_images_path, params: {image: {item_id: item.id, files: [fixture_file_upload("vertical.jpg", "image/jpeg")]}}
    assert_response :success
  end

  test "should upload be able to upload multiple images at one" do
    item = items(:football)

    files = [
      fixture_file_upload("vertical.jpg", "image/jpeg"),
      fixture_file_upload("horizontal.jpg", "image/jpeg")
    ]
    post editor_images_path, params: {image: {item_id: item.id, files: files}}
    assert_response :success
  end

  test "should update the position of an image" do
    image = images(:football_back2)

    patch editor_image_path(image), params: {position: 1}
    assert_response :success

    image.reload
    assert_equal image.position, 1, "Image was not positioned correctly"
  end

  test "should destroy an image" do
    image = images(:football_back2)

    delete editor_image_path(image)
    assert_response :success

    image.reload
    assert_not_nil image.deleted_at, "Image was not deleted"
  end
end
