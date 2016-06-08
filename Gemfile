# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rails', '5.0.0.rc1'
gem 'mysql2'

gem 'rack', '2.0.0.rc1'

gem 'valhammer',
    path: '../valhammer',
    branch: 'feature/loosen-activerecord-version'
gem 'accession'
gem 'aaf-lipstick',
    path: '../aaf-lipstick',
    branch: 'feature/unlock-sprockets-version'
gem 'slim-rails'
gem 'sass-rails'
gem 'torba-rails'
gem 'shib-rack',
    git: 'https://github.com/ausaccessfed/shib-rack',
    branch: 'develop'

gem 'unicorn', require: false
gem 'god', require: false

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'web-console', '~> 2.0', require: false
  gem 'rubocop', require: false
  gem 'simplecov', require: false
  gem 'capybara', require: false
  gem 'poltergeist', require: false
  gem 'guard', require: false
  gem 'guard-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-rspec', require: false
  gem 'guard-brakeman', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'aaf-gumboot',
      git: 'https://github.com/ausaccessfed/aaf-gumboot',
      branch: 'develop'
end
