require 'test_helper'

class PageStrippableTest < ActiveSupport::TestCase
  test 'strips spaces out of titles' do
    page = Page.create(title: 'My     Page ')
    assert_equal 'My Page', page.title
  end

  test 'strips different types of whitespace' do
    page = Page.create(title: "a\tb\nc\r\nd \t\t\n\r   e")
    assert_equal 'a b c d e', page.title
  end
end