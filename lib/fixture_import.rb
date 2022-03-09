# frozen_string_literal: true

require "active_record/fixtures"

module FixtureImport
  def self.load_fixtures(fixture_names)
    fixtures_dir = Rails.root.join("test", "fixtures")
    fixture_files = fixture_names

    ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, fixture_files)
  end
end
