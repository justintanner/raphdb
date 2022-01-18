require 'test_helper'

class SortTest < ActiveSupport::TestCase
  test 'should be associated with a view' do
    sort = Sort.new(field: fields(:number))
    assert_not sort.save, 'Sort should not be saved without a view'
  end

  test 'should be associated with a field' do
    sort = Sort.new(view: views(:default))
    assert_not sort.save, 'Sort should not be saved without a field'
  end

  test 'should have a direction of asc or desc' do
    sort = Sort.new(view: views(:default), direction: 'invalid')

    assert_not sort.save, 'Sort was saved with an invalid direction'
  end

  test 'should sort by position' do
    view = View.create!(title: 'Sort by three fields')
    second_sort = Sort.create(view: view, field: fields(:number), position: 2)
    first_sort = Sort.create(view: view, field: fields(:number), position: 1)
    third_sort = Sort.create(view: view, field: fields(:number), position: 3)

    sorts = Sort.all
    assert_equal sorts.first, first_sort, 'first_sort is not first'
    assert_equal sorts.second, second_sort, 'second_sort is not second'
    assert_equal sorts.third, third_sort, 'third_sort is not third'
  end
end
