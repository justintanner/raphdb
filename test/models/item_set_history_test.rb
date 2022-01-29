require 'test_helper'

class ItemSetHistoryTest < ActiveSupport::TestCase
  test 'tracks the creation in versions' do
    item_set = ItemSet.create(title: 'A')
    assert item_set.valid?, 'ItemSet was not valid'
    assert_equal item_set.versions.count, 1, 'ItemSet did not have a version'

    version = item_set.versions.first

    expected_changes = { 'title' => [nil, 'A'] }

    assert_equal expected_changes, version.data, 'Changes were not set'
    assert_equal 'create', version.action, 'Action was not set'
    assert_equal item_set, version.model, 'Model was not set'
    assert_equal 1, version.version, 'Version number was not 1'
  end

  test 'should track image uploads on the item_set' do
    item_set = ItemSet.create!(title: 'A')
    image = Image.create!(item_set: item_set)

    latest_version = item_set.versions.first

    assert_equal 'create', latest_version.action, 'Action was not set'
    assert_equal item_set, latest_version.model, 'Model was not set'
    assert_equal image, latest_version.associated, 'Associated was not set'
    assert_equal 2, latest_version.version, 'Version number was not 1'
  end

  test 'should track image deletions on the item_set' do
    item_set = ItemSet.create!(title: 'A')
    image = Image.create!(item_set: item_set)
    image.destroy

    latest_version = item_set.versions.first

    associated_image = Image.unscoped { latest_version.associated }

    assert_equal 'destroy', latest_version.action, 'Action was not set'
    assert_equal item_set, latest_version.model, 'Model was not set'
    assert_equal image, latest_version.associated, 'Associated was not set'
    assert_equal 3, latest_version.version, 'Version number was not 3'
  end
end
