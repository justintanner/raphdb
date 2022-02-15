# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should display a homepage from the root' do
    get '/'
    assert_response :success
  end

  test 'should display an about page from the root' do
    get '/about'
    assert_response :success
  end

  test 'old slugs should redirect to new slug urls' do
    page = Page.create(title: 'First')
    page.update(title: 'Second')

    get '/first'
    assert_response :moved_permanently
  end

  test 'should display a 404 for pages that are not found' do
    assert_raises(ActionController::RoutingError) { get '/not-found-at-all' }
  end
end
