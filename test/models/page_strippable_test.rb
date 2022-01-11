require 'test_helper'

class PageStrippableTest < ActiveSupport::TestCase
  test 'overridden slug gets spaces striped out' do
    page = Page.create(title: 'About my website', slug: ' ab  out  ')
    assert_equal 'about', page.slug
  end

  test 'strips spaces out of titles' do
    page = Page.create(title: 'My     Page ')
    assert_equal 'My Page', page.title
  end

  test 'strips spaces out of slugs' do
    page = Page.create(title: 'My     Page ')
    assert_equal 'my-page', page.slug
  end

  test 'strips different types of whitespace' do
    page = Page.create(title: 'a', slug: "all\tin one\nline\r\nno \t\t\n\r   breaks")
    assert_equal 'allinonelinenobreaks', page.slug
  end
end