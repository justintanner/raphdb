require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test 'should generate changes when an item is created' do
    item = item_create!({ item_title: 'First title' }, item_sets(:empty_set))

    version =
      Version.create!(
        model: item,
        model_changes: item.previous_changes,
        columns_to_version: [:data],
        action: 'create'
      )
    expected_data = {
      'data.item_title' => [nil, 'First title'],
      'data.set_title' => [nil, item_sets(:empty_set).title]
    }

    assert_equal expected_data,
                 version.data,
                 'Did not generate the expected changes'
  end

  test 'should generate changes when an item is updated' do
    item = item_create!(item_title: 'First title')

    item.data['item_title'] = 'Second title'

    version =
      Version.create!(
        model: item,
        model_changes: item.changes,
        columns_to_version: [:data],
        action: 'update'
      )
    expected_data = { 'data.item_title' => ['First title', 'Second title'] }

    assert_equal expected_data,
                 version.data,
                 'Did not generate the expected changes'
  end

  test 'should track changes on associated models' do
    item = item_create!(item_title: 'First title')
    image = Image.create!(item: item)

    first_version =
      Version.create!(
        model: item,
        model_changes: image.previous_changes,
        associated: image,
        columns_to_version: [],
        action: 'create'
      )

    assert_equal image,
                 first_version.associated,
                 'Did not associate the version with the image'
  end

  test 'should track changes destroy actions associated models' do
    item = item_create!(item_title: 'First title')
    image = Image.create!(item: item)
    item.destroy

    first_version =
      Version.create!(
        model: item,
        model_changes: image.previous_changes,
        associated: image,
        columns_to_version: [],
        action: 'destroy'
      )

    assert_equal image,
                 first_version.associated,
                 'Did not associate the version with the image'
  end
end
