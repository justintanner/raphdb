ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'helpers/open_fixture_helper'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers

  # Turned off for now because of errors running tests in parallel.
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include OpenFixtureHelper
end
