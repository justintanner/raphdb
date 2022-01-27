require 'test_helper'

class ItemSetHistoryTest < ActiveSupport::TestCase
  test 'tracks a history title changes' do
    freeze_time do
      item_set = ItemSet.create(title: 'A')
      assert item_set.valid?, 'ItemSet was not valid'

      expected_history = [
        {
          v: 1,
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

  test 'should track image uploads' do
    item_set = ItemSet.create!(title: 'A')
    image = Image.create!(item_set: item_set)

    expected_entry = { id: image.id }

    assert_equal expected_entry,
                 item_set.history.first[:image_uploaded],
                 'Image upload was not tracked'
  end

  test 'should track image deletions' do
    item_set = ItemSet.create!(title: 'A')
    image = Image.create!(item_set: item_set)
    image.destroy

    expected_entry = { id: image.id }

    assert_equal expected_entry,
                 item_set.history.first[:image_deleted],
                 'Image upload was not tracked'
  end
end
