# frozen_string_literal: true

require "test_helper"

class ImagesHelperTest < ActionView::TestCase
  def setup
    # Fake host to satisfy active storage in test.
    ActiveStorage::Current.url_options = {host: "localhost:9000"}
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test "returns img tag sizes strings for medium sized images" do
    image = image_create!(filename: "vertical.jpg", item: items(:football), process: true)

    actual_srcset = srcset(image, :medium_retina, :medium)
    assert actual_srcset.include?("314w"), "Couldn't find 314px in srcset"
    assert actual_srcset.include?("157w"), "Couldn't find 157px in srcset"
  end
end
