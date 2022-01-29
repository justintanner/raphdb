require 'test_helper'

class ItemHistoryTest < ActiveSupport::TestCase
  test 'should return history newest to oldest' do
    item = item_create!({ item_title: 'A' })
    item.data['item_title'] = 'B'
    item.save!

    assert item.versions.first.created_at > item.versions.last.created_at,
           'History was not returned newest to oldest'
  end

  test 'should return multiple changes in the order they changed' do
    item = item_create!({ item_title: 'A' })
    item.update(data: { item_title: 'B' })
    item.update(data: { item_title: 'C' })

    assert_equal [3, 2, 1],
                 item.versions.map(&:version),
                 'History was not returned newest to oldest'

    expected_changes = [%w[B C], %w[A B], [nil, 'A']]

    actual_changes =
      item.versions.map { |version| version.data['data.item_title'] }

    assert_equal expected_changes,
                 actual_changes,
                 'Changes where not tracked correctly'
  end

  test 'should track image uploads' do
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)

    assert_equal image,
                 item.versions.first.associated,
                 'Image upload was not tracked'
  end

  test 'should track image deletions' do
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)
    image.destroy

    associated_image = Image.unscoped { item.versions.first.associated }
    assert_equal image, associated_image, 'Image destruction was not tracked'
  end

  test 'should track multiple selects' do
    item =
      item_create!(
        { item_title: 'A', tags: multiple_selects(:golf, :queen).map(&:title) }
      )
    item.data['tags'] = multiple_selects(:golf, :queen, :king).map(&:title)
    item.save!

    expected_data = {
      'data.tags' => [
        multiple_selects(:golf, :queen).map(&:title),
        multiple_selects(:golf, :queen, :king).map(&:title)
      ]
    }

    assert_equal expected_data,
                 item.versions.first.data,
                 'Tags were not tracked correctly'
  end
end
