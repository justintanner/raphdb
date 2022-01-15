require 'test_helper'

class ItemSetHistoryTest < ActiveSupport::TestCase
  test 'tracks a history title changes' do
    freeze_time do
      item_set = ItemSet.create(title: 'A')
      assert item_set.valid?, 'ItemSet was not valid'

      expected_history = [
        {
          ts: Time.now.to_i,
          user_id: nil, # TODO: Set the current user.
          changes: [
            { attribute: 'title', inner_attribute: nil, from: nil, to: 'A' }
          ]
        }
      ]

      assert_equal expected_history, item_set.history, 'History was not created'
    end
  end
end
