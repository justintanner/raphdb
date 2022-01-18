require 'test_helper'

class ViewTest < ActiveSupport::TestCase
  test 'should not save without a title' do
    view = View.new
    assert_not view.save, 'Saved the view without a title'
  end

  test 'should soft delete' do
    view = View.create!(title: 'Test View')
    assert view.destroy, 'Failed to destroy view'

    assert_not view.destroyed?, 'View was hard deleted'
  end

  test 'there can be only one default' do
    default_view = views(:default)
    reverse_view = View.create!(title: 'Reverse', default: true)

    default_view.reload

    assert_not default_view.default, 'Old default view is still default'
    assert reverse_view.default, 'Reversed is not the new default view'

    # Resetting this view to default because it's a fixture
    default_view.update(default: true)
    reverse_view.reload

    assert default_view.default, 'Old default did not return to default'
    assert_not reverse_view.default,
               'Reversed still has a default status of true'
  end
end
