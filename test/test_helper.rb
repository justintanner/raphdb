# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "support/open_fixture_helper"
require "support/item_helper"
require "support/image_helper"

module ActiveSupport
  class TestCase
    # Turned off parallel tests for now because of errors related to active storage.
    # NOTE: This M1 mac setting "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES" helped but didn't fix the problem.
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    include OpenFixtureHelper
    include ItemHelper
    include ImageHelper
    include Devise::Test::IntegrationHelpers
  end
end

Minitest.after_run do
  FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
end
