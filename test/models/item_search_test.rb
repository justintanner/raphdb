require 'test_helper'

class ItemSearchTest < ActiveSupport::TestCase
  test 'should match a keyword in the item' do
    item =
      Item.create!(
        fields: {
          item_title: 'apple'
        },
        item_set: item_sets(:default)
      )
    results = Item.search('apple')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore whitespace' do
    item =
      Item.create!(
        fields: {
          item_title: 'apple'
        },
        item_set: item_sets(:default)
      )
    results = Item.search(" \n\t apple \t\n")

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore deleted items' do
    item =
      Item.create!(
        fields: {
          item_title: 'apple'
        },
        item_set: item_sets(:default),
        deleted_at: Time.now
      )
    results = Item.search('apple')

    assert_empty results, 'Results were not empty'
  end

  test 'should match a keyword in two items' do
    first_item =
      Item.create!(
        fields: {
          item_title: 'apple'
        },
        item_set: item_sets(:default)
      )
    second_item =
      Item.create!(
        fields: {
          item_title: 'banana'
        },
        item_set: item_sets(:default)
      )
    results = Item.search('apple banana')

    assert_includes results.to_a, first_item, 'First item was not matched'
    assert_includes results.to_a, second_item, 'Second item was not matched'
  end

  test 'should match two keywords in a single item' do
    item =
      Item.create!(
        fields: {
          item_title: 'apple banana'
        },
        item_set: item_sets(:default)
      )
    results = Item.search('apple banana')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should match two keywords in a single item spread over multiple fields' do
    item =
      Item.create!(
        fields: {
          item_title: 'apple',
          fruit: 'banana'
        },
        item_set: item_sets(:default)
      )
    results = Item.search('apple banana')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should match numbers' do
    skip 'TODO: restrict fields values to strings only, or make this work'
    item =
      Item.create!(
        fields: {
          item_title: 'apple',
          number: 5001
        },
        item_set: item_sets(:default)
      )
    results = Item.search('5001')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should default to limiting results to 100' do
    101.times do |n|
      Item.create!(
        fields: {
          item_title: n.to_s,
          fruit: 'apple'
        },
        item_set: item_sets(:default)
      )
    end

    results = Item.search('apple')

    assert_equal 100, results.count, 'Wrong number of results'
  end

  test 'should return results by page' do
    100.times do |n|
      Item.create!(
        fields: {
          item_title: n.to_s,
          fruit: 'apple'
        },
        item_set: item_sets(:default)
      )
    end

    last_item =
      Item.create!(
        fields: {
          item_title: 'zzzlast',
          fruit: 'apple'
        },
        item_set: item_sets(:default)
      )

    results = Item.search('apple', page: 2)

    assert_equal results.first, last_item, 'Last item on page 2 was not found'
  end

  test 'should limit results with per_page' do
    20.times do |n|
      Item.create!(
        fields: {
          item_title: n.to_s,
          fruit: 'apple'
        },
        item_set: item_sets(:default)
      )
    end

    results = Item.search('apple', per_page: 10)

    assert_equal 10, results.count, 'Wrong number of results'
  end
end
