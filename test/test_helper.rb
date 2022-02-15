# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "helpers/open_fixture_helper"
require "helpers/item_create_helper"

module ActiveSupport
  class TestCase
    # NOTE: this M1 mac setting helped "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
    # Turned off parallel tests for now because of errors related to active storage.
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    include OpenFixtureHelper
    include ItemCreateHelper
    include Devise::Test::IntegrationHelpers
  end
end

Minitest.after_run do
  FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
end
