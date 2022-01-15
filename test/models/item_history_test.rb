require 'test_helper'

class ItemHistoryTest < ActiveSupport::TestCase
  test 'should track a history changes to the item' do
    freeze_time do
      item =
        Item.create(fields: { item_title: 'A' }, item_set: item_sets(:default))
      assert item.valid?, 'Item was not valid'

      expected_changes = [
        {
          ts: Time.now.to_i,
          user_id: nil, # TODO: Set the current user.
          changes: [
            {
              attribute: 'fields',
              inner_attribute: 'item_title',
              from: nil,
              to: 'A'
            },
            {
              attribute: 'fields',
              inner_attribute: 'set_title',
              from: nil,
              to: item_sets(:default).title
            },
            {
              attribute: 'item_set_id',
              inner_attribute: nil,
              from: nil,
              to: item_sets(:default).id
            }
          ]
        }
      ]

      assert_equal expected_changes, item.changes, 'History was not tracked'
    end
  end

  test 'should return multiple changes in the order they changed' do
    item =
      Item.create(fields: { item_title: 'A' }, item_set: item_sets(:default))
    assert item.valid?, 'Item was not valid'

    item.update(fields: { item_title: 'B' })
    item.update(fields: { item_title: 'C' })

    item_title_changes =
      item
        .changes
        .flat_map { |entry| entry[:changes] }
        .select { |change| change[:inner_attribute] == 'item_title' }

    assert_equal 'A',
                 item_title_changes.first[:to],
                 'First change was not tracked'
    assert_equal 'B',
                 item_title_changes.second[:to],
                 'Second change was not tracked'
    assert_equal 'C',
                 item_title_changes.third[:to],
                 'Third change was not tracked'
  end
end
