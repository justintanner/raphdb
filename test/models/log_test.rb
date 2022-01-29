require 'test_helper'

class LogTest < ActiveSupport::TestCase
  test 'should generate changes when an item is created' do
    item =
      Item.new(
        data: {
          item_title: 'First title'
        },
        item_set: item_sets(:empty_set)
      )

    log =
      Log.create!(model: item, loggable_changes: item.changes, action: 'create')

    expected_entry = {
      'data.item_title' => [nil, 'First title'],
      'data.set_title' => [nil, item_sets(:empty_set).title],
      'item_set_id' => [nil, item_sets(:empty_set).id]
    }

    assert_equal expected_entry,
                 log.entry,
                 'Did not generate the expected changes'
  end

  test 'should generate changes when an item is updated' do
    item = item_create!(item_title: 'First title')

    item.data['item_title'] = 'Second title'

    log =
      Log.create!(model: item, loggable_changes: item.changes, action: 'update')

    expected_entry = { 'data.item_title' => ['First title', 'Second title'] }

    assert_equal expected_entry,
                 log.entry,
                 'Did not generate the expected changes'
  end

  test 'should track changes on associated models' do
    item = item_create!(item_title: 'First title')
    image = Image.create!(item: item)

    first_log =
      Log.create!(
        model: item,
        loggable_changes: image.previous_changes,
        associated: image,
        action: 'create'
      )

    assert_equal image,
                 first_log.associated,
                 'Did not associate the log with the image'
  end

  test 'should track changes destroy actions associated models' do
    item = item_create!(item_title: 'First title')
    image = Image.create!(item: item)
    item.destroy

    first_log =
      Log.create!(
        model: item,
        loggable_changes: image.previous_changes,
        associated: image,
        action: 'destroy'
      )

    assert_equal image,
                 first_log.associated,
                 'Did not associate the log with the image'
  end
end
