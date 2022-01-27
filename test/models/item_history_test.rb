require 'test_helper'

class ItemHistoryTest < ActiveSupport::TestCase
  test 'should track a history changes to the item' do
    freeze_time do
      item = item_create!({ item_title: 'A' })

      expected_history = [
        {
          v: 1,
          ts: Time.now.to_i,
          user_id: nil, # TODO: Set the current user.
          changes: [
            {
              attribute: 'data',
              inner_attribute: 'item_title',
              from: nil,
              to: 'A'
            },
            {
              attribute: 'data',
              inner_attribute: 'set_title',
              from: nil,
              to: item_sets(:orphan).title
            },
            {
              attribute: 'item_set_id',
              inner_attribute: nil,
              from: nil,
              to: item_sets(:orphan).id
            }
          ]
        }
      ]

      assert_equal expected_history, item.history, 'History was not tracked'
    end
  end

  test 'should return history newest to oldest' do
    item = item_create!({ item_title: 'A' })
    item.data['item_title'] = 'B'
    item.save!

    assert item.history.first[:v] > item.history.last[:v],
           'History was not returned newest to oldest'
  end

  test 'should return multiple changes in the order they changed' do
    item = item_create!({ item_title: 'A' })
    assert item.valid?, 'Item was not valid'

    item.update(data: { item_title: 'B' })
    item.update(data: { item_title: 'C' })

    item_title_changes =
      item
        .history
        .flat_map { |entry| entry[:changes] }
        .select { |change| change[:inner_attribute] == 'item_title' }

    assert_not_empty item_title_changes, 'No body changes found'

    assert_equal 'C',
                 item_title_changes.first[:to],
                 'Third change was not tracked'
    assert_equal 'B',
                 item_title_changes.second[:to],
                 'Second change was not tracked'
    assert_equal 'A',
                 item_title_changes.third[:to],
                 'first change was not tracked'
  end

  test 'rails timestamps should match history timestamps' do
    item = item_create!({ item_title: 'A' })

    assert item.save!, 'Item was not saved'

    assert_equal item.created_at.to_time.to_i,
                 item.history.first[:ts].to_i,
                 'created_at does not match history timestamp'

    item.update(data: { item_title: 'B' })

    assert_equal item.updated_at.to_time.to_i,
                 item.history.second[:ts].to_i,
                 'updated_at does not match history timestamp'
  end

  test 'should track image uploads' do
    # Don't need to actually attach to test versioning of an Image record.
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)

    expected_entry = { id: image.id }

    assert_equal expected_entry,
                 item.history.first[:image_uploaded],
                 'Image upload was not tracked'
  end

  test 'should track image deletions' do
    item = item_create!({ item_title: 'A' })
    image = Image.create!(item: item)
    image.destroy

    expected_entry = { id: image.id }

    assert_equal expected_entry,
                 item.history.first[:image_deleted],
                 'Image upload was not tracked'
  end

  test 'should track multiple selects' do
    item =
      item_create!(
        { item_title: 'A', tags: multiple_selects(:golf, :queen).map(&:title) }
      )
    item.data['tags'] = multiple_selects(:golf, :queen, :king).map(&:title)
    item.save!

    expected_changes = [
      {
        attribute: 'data',
        inner_attribute: 'tags',
        from: multiple_selects(:golf, :queen).map(&:title),
        to: multiple_selects(:golf, :queen, :king).map(&:title)
      }
    ]

    tag_changes =
      item.history.first[:changes].select do |change|
        change[:inner_attribute] == 'tags'
      end

    assert_equal expected_changes,
                 tag_changes,
                 'Tags were not tracked correctly'
  end
end
