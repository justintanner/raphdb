require "test_helper"

class AnalyzeAndProcessImageJobTest < ActiveJob::TestCase
  def setup
    # Fake host to satisfy active storage in test.
    ActiveStorage::Current.url_options = {host: "localhost:9000"}
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test "should create all variants of an image, analyze them and set a flag" do
    image = Image.create!(item: items(:football))
    image.file.attach(io: open_fixture("horizontal.jpg"), filename: "horizontal.jpg")

    AnalyzeAndProcessImageJob.perform_now(image.id)

    image.reload

    assert image.file.attached?, "Image should be attached"
    assert image.file.analyzed?, "Image should be analyzed"
    assert image.processed_at, "Flag was not set"

    Image::SIZES.each do |name, _dimensions|
      assert image.file.variant(name).send(:record).image.blob.analyzed?
    end
  end
end
