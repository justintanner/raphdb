ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'helpers/open_fixture_helper'
require 'helpers/item_create_helper'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers

  # Turned off for now because of errors running tests in parallel.
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include OpenFixtureHelper
  include ItemCreateHelper
end

Minitest.after_run do
  FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
end
