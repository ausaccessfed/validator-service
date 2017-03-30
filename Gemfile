# frozen_string_literal: true
source 'https://rubygems.org'

gem 'mysql2'
gem 'rails', '>= 5.0.0', '< 5.1'

gem 'aaf-lipstick'
gem 'accession'
gem 'sass-rails', require: false
gem 'shib-rack'
gem 'slim-rails'
gem 'super-identity'
gem 'therubyracer', require: false
gem 'torba-rails'
gem 'uglifier', require: false
gem 'valhammer'

gem 'god', require: false
gem 'puma', require: false

gem 'pdfkit'
gem 'wkhtmltopdf-binary'

gem 'coffee-script'

gem 'local_time'
gem 'rails_admin'
gem 'remotipart', git: 'https://github.com/mshibuya/remotipart', require: false

group :production do
  gem 'aaf-secure_headers'
end

group :development, :test do
  gem 'aaf-gumboot'
  gem 'bullet'
  gem 'capybara', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard', require: false
  gem 'guard-brakeman', require: false
  gem 'guard-bundler', require: false
  gem 'guard-rspec',
      git: 'https://github.com/guard/guard-rspec',
      branch: 'rails-5-support',
      require: false
  gem 'guard-rubocop', require: false
  gem 'poltergeist', require: false
  gem 'pry'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5.0.beta4'
  gem 'rubocop', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'timecop'
  gem 'web-console', '~> 2.0', require: false
  gem 'webmock', require: false
end
