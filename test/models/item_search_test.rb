# frozen_string_literal: true

require 'test_helper'

class ItemSearchTest < ActiveSupport::TestCase
  test 'should match a keyword in the item' do
    item = item_create!({ item_title: 'apple' })
    results = Item.search('apple')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore whitespace' do
    item = item_create!({ item_title: 'apple' })
    results = Item.search(" \n\t apple \t\n")

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore case in data' do
    item = item_create!({ item_title: 'APPLE' })
    results = Item.search('apple')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore case in query' do
    item = item_create!({ item_title: 'apple' })
    results = Item.search('APPLE')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should ignore deleted items' do
    Item.create!(
      data: {
        item_title: 'apple'
      },
      item_set: item_sets(:orphan),
      deleted_at: Time.now
    )
    results = Item.search('apple')

    assert_empty results, 'Results were not empty'
  end

  test 'should match a keyword in two items' do
    first_item = item_create!({ item_title: 'apple' })
    second_item = item_create!({ item_title: 'banana' })
    results = Item.search('apple banana')

    assert_includes results.to_a, first_item, 'First item was not matched'
    assert_includes results.to_a, second_item, 'Second item was not matched'
  end

  test 'should match two keywords in a single item' do
    item = item_create!({ item_title: 'apple banana' })
    results = Item.search('apple banana')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should match two keywords in a single item spread over multiple data fields' do
    item = item_create!({ item_title: 'apple', item_comment: 'banana' })
    results = Item.search('apple banana')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should match numbers' do
    item = item_create!({ item_title: 'apple banana', number: 5001 })
    results = Item.search('5001')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should find fields with prefixes without spaces' do
    item = item_create!({ item_title: 'cherry', prefix: 'A', number: 5001 })
    results = Item.search('A5001')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should find fields with suffixes without spaces' do
    item = item_create!({ item_title: 'cherry', number: 5001, in_set: 'Z' })
    results = Item.search('5001Z')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should default to limiting results to 100' do
    101.times do |n|
      item_create!({ item_title: n.to_s, item_comment: 'apple' })
    end

    results = Item.search('apple')

    assert_equal 100, results.count, 'Wrong number of results'
  end

  test 'should return results by page' do
    100.times do |n|
      item_create!({ item_title: n.to_s, item_comment: 'apple' })
    end

    last_item = item_create!({ item_title: 'zlast', item_comment: 'apple' })
    results = Item.search('apple', page: 2)

    assert_equal results.first, last_item, 'Last item on page 2 was not found'
  end

  test 'should limit results with per_page' do
    20.times { |n| item_create!({ item_title: n.to_s, item_comment: 'apple' }) }

    results = Item.search('apple', per_page: 10)

    assert_equal 10, results.count, 'Wrong number of results'
  end

  test 'should sort by the default sort order' do
    9.downto(1) { |n| item_create!({ item_title: "#{n} apple(s)" }) }

    results = Item.search('apple')

    assert_equal results.first.data['item_title'],
                 '1 apple(s)',
                 'Wrong first item'
    assert_equal results.last.data['item_title'],
                 '9 apple(s)',
                 'Wrong last item'
  end

  test 'should sort by numeric values' do
    9.downto(1) { |n| item_create!({ item_title: 'apple', number: n }) }

    results = Item.search('apple')

    assert_equal results.first.data['number'], 1, 'Wrong first item'
    assert_equal results.last.data['number'], 9, 'Wrong last item'
  end

  test 'should be able to search by number ranges' do
    1.upto(5) { |n| item_create!({ item_title: 'apple', number: n }) }
    6.upto(11) { |n| item_create!({ item_title: 'apple', number: n }) }

    results = Item.search('apple number: 1-5')

    assert_equal results.count, 5, 'Wrong number of results'
    assert_equal results.first.data['number'], 1, 'Wrong first item'
    assert_equal results.last.data['number'], 5, 'Wrong last item'
  end

  test 'should be able to search limit to one field' do
    match_item = item_create!({ item_title: 'cherry-banana', number: 2 })
    dont_match_item =
      item_create!(
        { item_title: 'A', item_comment: 'cherry-banana', number: 1 }
      )

    results = Item.search('item_title: "cherry-banana"')

    assert_includes results, match_item, 'Item was not found'
    assert_not_includes results, dont_match_item, 'Item was not found'
  end

  test 'should be able to match by two advanced criteria at once' do
    items =
      1
      .upto(5)
      .map { |n| item_create!({ item_title: 'cherry-banana', number: n }) }

    results = Item.search('item_title: "cherry-banana" number: 1-5')

    assert_equal results.first, items.first, 'First item was not found'
    assert_equal results.last, items.last, 'Last item was not found'
  end

  test 'should be able to exact match an integer' do
    item = item_create!({ item_title: 'apple', number: 9001 })

    results = Item.search('number: 9001')

    assert_equal results.first, item, 'Item was not found'
  end

  test 'should be able to partially match within a specific field' do
    item = item_create!({ item_title: 'apple-banana-cherry' })

    results = Item.search('item_title: "banana"')

    assert_equal results.first, item, 'Item was not found'
  end
end
