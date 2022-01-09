require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test 'should not save page without title' do
    page = Page.new
    assert_not page.save, 'Saved the page without a title'
  end

  test 'creates a slug based on the title' do
    page = Page.create(title: 'My Page')
    assert_equal 'my-page', page.slug
  end

  test 'strips spaces out of titles' do
    page = Page.create(title: 'My     Page ')
    assert_equal 'My Page', page.title
  end

  test 'strips spaces out of slugs' do
    page = Page.create(title: 'My     Page ')
    assert_equal 'my-page', page.slug
  end
end
