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

  test 'should match two keywords in a single item spread over multiple fields' do
    item = item_create!({ item_title: 'apple', fruit: 'banana' })
    results = Item.search('apple banana')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should match numbers' do
    skip 'TODO: Add searchable number fields to fields'
    item = item_create!({ item_title: 'apple banana', number: 5001 })
    results = Item.search('5001')

    assert_equal item, results.first, 'Item was not found'
  end

  test 'should default to limiting results to 100' do
    101.times { |n| item_create!({ item_title: n.to_s, fruit: 'apple' }) }

    results = Item.search('apple')

    assert_equal 100, results.count, 'Wrong number of results'
  end

  test 'should return results by page' do
    100.times { |n| item_create!({ item_title: n.to_s, fruit: 'apple' }) }

    last_item = item_create!({ item_title: 'zlast', fruit: 'apple' })
    results = Item.search('apple', page: 2)

    assert_equal results.first, last_item, 'Last item on page 2 was not found'
  end

  test 'should limit results with per_page' do
    20.times { |n| item_create!({ item_title: n.to_s, fruit: 'apple' }) }

    results = Item.search('apple', per_page: 10)

    assert_equal 10, results.count, 'Wrong number of results'
  end

  # TODO: Update this to use the default sort order in the Views model.
  test 'should sort by the default sort order' do
    9.downto(1) { |n| item_create!({ item_title: n.to_s + ' apple(s)' }) }

    results = Item.search('apple')

    assert_equal results.first.fields['item_title'],
                 '1 apple(s)',
                 'Wrong first item'
    assert_equal results.last.fields['item_title'],
                 '9 apple(s)',
                 'Wrong last item'
  end

  test 'should sort by numeric values' do
    9.downto(1) { |n| item_create!({ item_title: 'apple', number: n }) }

    results = Item.search('apple')

    assert_equal results.first.fields['number'], 1, 'Wrong first item'
    assert_equal results.last.fields['number'], 9, 'Wrong last item'
  end
end