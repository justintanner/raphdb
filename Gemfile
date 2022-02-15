# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Bootstrap 5 [https://github.com/twbs/bootstrap-rubygem]
# Please manually upgrade bootstrap to avoid breaking the app
gem "bootstrap", "5.1.3"

# Generates slugs for urls and other helpers [https://github.com/norman/friendly_id]
gem "friendly_id"

# Authentication and authorization [https://github.com/heartcombo/devise]
gem "devise"

# Omniauth support for devise [https://github.com/omniauth/omniauth]
gem "omniauth"

# Inviting users to sign up [https://github.com/scambra/devise_invitable]
gem "devise_invitable"

# Currency formatting [https://github.com/RubyMoney/money]
gem "money"

# Currency parsing [https://github.com/RubyMoney/monetize]
gem "monetize"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Find N+1 queries [https://github.com/flyerhzm/bullet]
  gem "bullet"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Code formatting [https://github.com/rubocop/rubocop]
  gem "rubocop", require: false

  # Prettier like code formatted for ruby [https://github.com/testdouble/standard]
  gem "standard", require: false

  # Profile [https://ruby-prof.github.io/]
  gem "ruby-prof"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
