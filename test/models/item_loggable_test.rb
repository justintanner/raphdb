require 'test_helper'

class ItemLoggableTest < ActiveSupport::TestCase
  test 'should return log entries newest to oldest' do
    item = item_create!({ item_title: 'A' })
    item.data['item_title'] = 'B'
    item.save!

    assert item.logs.first.created_at > item.logs.last.created_at,
           'Log was not returned newest to oldest'
  end

  test 'should return multiple changes in the order they changed' do
    item = item_create!({ item_title: 'A' })
    item.update(data: { item_title: 'B' })
    item.update(data: { item_title: 'C' })

    assert_equal [3, 2, 1],
                 item.logs.map(&:version),
                 'Log was not returned newest to oldest'

    expected_changes = [%w[B C], %w[A B], [nil, 'A']]

    actual_changes = item.logs.map { |log| log.entry['data.item_title'] }

    assert_equal expected_changes,
                 actual_changes,
                 'Changes where not tracked correctly'
  end

  test 'should track image uploads' do
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)

    assert_equal image,
                 item.logs.first.associated,
                 'Image upload was not tracked'
  end

  test 'should track image deletions' do
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)
    image.destroy

    associated_image = Image.unscoped { item.logs.first.associated }
    assert_equal image, associated_image, 'Image destruction was not tracked'
  end

  test 'should track multiple selects' do
    item =
      item_create!(
        { item_title: 'A', tags: multiple_selects(:golf, :queen).map(&:title) }
      )
    item.data['tags'] = multiple_selects(:golf, :queen, :king).map(&:title)
    item.save!

    expected_entry = {
      'data.tags' => [
        multiple_selects(:golf, :queen).map(&:title),
        multiple_selects(:golf, :queen, :king).map(&:title)
      ]
    }

    assert_equal expected_entry,
                 item.logs.first.entry,
                 'Tags were not tracked correctly'
  end
end
