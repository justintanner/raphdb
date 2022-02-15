# frozen_string_literal: true

require 'test_helper'

class SearchProcessorTest < ActiveSupport::TestCase
  test 'should extract number range from search query' do
    remaining_query, advanced =
      SearchProcessor.extract_advanced('apple number:1-1000')

    expected_advanced = [{ op: 'range', key: 'number', from: 1, to: 1000 }]
    assert_equal expected_advanced,
                 advanced,
                 'Range was not extracted correctly'
    assert_equal remaining_query, 'apple', 'Remaining query was not correct'
  end

  test 'should extract a number range as the first option' do
    remaining_query, advanced =
      SearchProcessor.extract_advanced('number: 99-100 bananas')

    expected_advanced = [{ op: 'range', key: 'number', from: 99, to: 100 }]
    assert_equal expected_advanced,
                 advanced,
                 'Range was not extracted correctly'
    assert_equal remaining_query, 'bananas', 'Remaining query was not correct'
  end
end
