require 'test_helper'

class ImagePositionableTest < ActiveSupport::TestCase
  test 'should have a default position of 1' do
    image = Image.create!(item: items(:one))
    assert_equal image.position, 1, 'Position is not 1'
  end

  test 'should automatically position in the next spot' do
    first_image = Image.create!(item: items(:one))
    second_image = Image.create!(item: items(:one))

    assert_equal first_image.position, 1, 'First item image position is not 1'
    assert_equal second_image.position, 2, 'Second item image position is not 2'
  end

  test 'should sort by position' do
    third_image = Image.create!(item: items(:one), position: 3)
    first_image = Image.create!(item: items(:one), position: 1)
    second_image = Image.create!(item: items(:one), position: 2)

    assert_equal Image.all,
                 [first_image, second_image, third_image],
                 'Images are not sorted by position'
  end

  test 'moving first to second should re-position items' do
    first_image = Image.create!(item: items(:one), position: 1)
    second_image = Image.create!(item: items(:one), position: 2)
    third_image = Image.create!(item: items(:one), position: 3)

    first_image.move_to(2)

    [first_image, second_image, third_image].each(&:reload)

    assert_equal first_image.position,
                 2,
                 'First item was not re-positioned to 2'
    assert_equal second_image.position,
                 1,
                 'Second item was not re-positioned to 1'
    assert_equal third_image.position,
                 3,
                 'Third item was not re-positioned to 3'
  end

  test 'moving third to first should re-position items' do
    first_image = Image.create!(item: items(:one), position: 1)
    second_image = Image.create!(item: items(:one), position: 2)
    third_image = Image.create!(item: items(:one), position: 3)

    third_image.move_to(1)

    first_image.reload
    second_image.reload
    third_image.reload

    assert_equal third_image.position,
                 1,
                 'Third item was not re-positioned to 1'
    assert_equal first_image.position,
                 2,
                 'First item was not re-positioned to 2'
    assert_equal second_image.position,
                 3,
                 'Second item was not re-positioned to 3'
  end

  test 'positioning should not bleed into other items' do
    one_first = Image.create!(item: items(:one))
    one_second = Image.create!(item: items(:one))

    two_first = Image.create!(item: items(:two))
    two_second = Image.create!(item: items(:two))

    assert_equal one_first.position, 1, 'First item image position is not 1'
    assert_equal one_second.position, 2, 'Second item image position is not 2'

    assert_equal two_first.position, 1, 'First item image position is not 1'
    assert_equal two_second.position, 2, 'Second item image position is not 2'
  end

  test 'moving items should should not bleed into other items' do
    one_first = Image.create!(item: items(:one), position: 1)
    one_second = Image.create!(item: items(:one), position: 2)

    two_first = Image.create!(item: items(:two), position: 1)
    two_second = Image.create!(item: items(:two), position: 2)
    two_third = Image.create!(item: items(:two), position: 3)
    two_fourth = Image.create!(item: items(:two), position: 4)

    two_fourth.move_to(1)

    [one_first, one_second, two_first, two_second, two_third, two_fourth].each(
      &:reload
    )

    assert_equal one_first.position, 1, 'One first item image position is not 1'
    assert_equal one_second.position,
                 2,
                 'One second item image position is not 2'

    assert_equal two_first.position, 2, 'Two first was not re-positioned to 2'
    assert_equal two_second.position, 3, 'Two second was not re-positioned to 3'
    assert_equal two_third.position, 4, 'Two third was not re-positioned to 4'
    assert_equal two_fourth.position, 1, 'Two fourth was not re-positioned to 1'
  end

  test 'should be able to position images for item_sets as well' do
    first_image = Image.create!(item_set: item_sets(:default))
    second_image = Image.create!(item_set: item_sets(:default))
    third_image = Image.create!(item_set: item_sets(:default))

    third_image.move_to(2)

    [first_image, second_image, third_image].each(&:reload)

    assert_equal first_image.position, 1, 'First image was not left alone'
    assert_equal second_image.position,
                 3,
                 'Second image was not re-positioned to 3'
    assert_equal third_image.position,
                 2,
                 'Third image was not re-positioned to 2'
  end
end