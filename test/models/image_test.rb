require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test 'should not save without an item or item_set' do
    image = Image.new
    assert_not image.save, 'Saved without an item or item_set'
  end

  test 'should be able to manually attach an file' do
    image = Image.create!(item: items(:one))
    image.attach(io: open_fixture('horizontal.jpg'), filename: 'horizontal.jpg')

    assert image.file.attached?, 'File not attached'
  end

  test 'should be able to attach multiple images' do
    item = items(:one)

    horizontal = Image.create!(item: item)
    horizontal.attach(
      io: open_fixture('horizontal.jpg'),
      filename: 'horizontal.jpg'
    )

    vertical = Image.create!(item: item)
    vertical.attach(io: open_fixture('vertical.jpg'), filename: 'vertical.jpg')

    assert_includes item.images, horizontal, 'Horizontal image not found'
    assert_includes item.images, vertical, 'Vertical image not found'
  end

  test 'should be able to iterate all images using the active storage helper with_attached_file' do
    item = items(:one)

    horizontal = Image.create!(item: item)
    horizontal.attach(
      io: open_fixture('horizontal.jpg'),
      filename: 'horizontal.jpg'
    )

    vertical = Image.create!(item: item)
    vertical.attach(io: open_fixture('vertical.jpg'), filename: 'vertical.jpg')

    item.images.with_attached_file.each do |image|
      assert_kind_of Image, image, 'Image is not an Image'
    end
  end
end
