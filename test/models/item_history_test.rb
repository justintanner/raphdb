require 'test_helper'

class ItemHistoryTest < ActiveSupport::TestCase
  test 'tracks a history title changes' do
    freeze_time do
      item =
        Item.create(
          fields: {
            item_title: 'Initial title'
          },
          item_set: item_sets(:default)
        )
      assert item.valid?, 'Item was not valid'

      expected_history = {
        h: [
          {
            ts: Time.now.to_i,
            user_id: nil, # TODO: Set the current user.
            c: [
              {
                attr: 'fields',
                inner_attr: 'item_title',
                from: nil,
                to: 'Initial title'
              },
              {
                attr: 'fields',
                inner_attr: 'set_title',
                from: nil,
                to: item_sets(:default).title
              },
              { attr: 'item_set_id', from: nil, to: item_sets(:default).id }
            ]
          }
        ]
      }.deep_stringify_keys

      assert_equal expected_history, item.history, 'History was not created'
    end
  end
end
