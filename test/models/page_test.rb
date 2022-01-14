require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test 'should not save page without title' do
    page = Page.new
    assert_not page.save, 'Saved the page without a title'
  end

  test 'creates a slug based on the title' do
    page = Page.create(title: 'My Page')
    assert_equal 'my-page', page.friendly_id
    assert_equal 'my-page', page.slug
  end

  test 'finds a page by slug' do
    page = Page.create(title: 'My Page')
    assert_equal Page.friendly.find('my-page'), page
  end

  test 'changing the title changes the slug' do
    page = Page.create(title: 'First')
    assert_equal 'first', page.friendly_id

    page.update(title: 'Renamed')
    assert_equal 'renamed', page.friendly_id
    assert_equal 'renamed', page.slug
  end

  test 'keeps a history of old slugs' do
    page = Page.create(title: '1')
    page.update(title: '2')
    page.update(title: '3')

    assert_equal FriendlyId::Slug.pluck(:slug).sort, %w[1 2 3]
  end

  test 'should soft delete pages' do
    page = Page.create(title: 'Delete me')

    assert page.destroy, 'Failed to destroy page'
    assert_not page.destroyed?, 'Page was hard deleted'
  end

  test 'should set a deleted_at timestamp when soft deleting' do
    freeze_time do
      page = Page.create(title: 'Delete me')

      assert page.destroy, 'Failed to destroy page'
      assert_equal page.deleted_at, Time.now, 'Page has the wrong deleted_at'
    end
  end

  test 'should not include deleted items when querying items' do
    page = Page.create(title: 'Delete me')

    assert page.destroy, 'Failed to destroy item'
    assert_not_includes Page.all, page, 'Found deleted page in all pages'
  end
end
