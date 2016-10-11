# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rails', '>= 5.0.0', '< 5.1'
gem 'mysql2'

gem 'valhammer'
gem 'accession'
gem 'super-identity'
gem 'aaf-lipstick',
    git: 'https://github.com/ausaccessfed/aaf-lipstick.git',
    branch: 'feature/errors'
gem 'slim-rails'
gem 'sass-rails', require: false
gem 'uglifier', require: false
gem 'therubyracer', require: false
gem 'torba-rails'
gem 'shib-rack',
    git: 'https://github.com/ausaccessfed/shib-rack',
    branch: 'develop'

gem 'puma', require: false
gem 'god', require: false

gem 'wkhtmltopdf-binary'
gem 'pdfkit'

gem 'coffee-script'

gem 'remotipart', github: 'mshibuya/remotipart', require: false
gem 'rails_admin'
gem 'ckeditor'

group :production do
  gem 'aaf-secure_headers'
end

group :development, :test do
  gem 'bullet'
  gem 'pry'
  gem 'rspec-rails', '~> 3.5.0.beta4'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'
  gem 'webmock', require: false
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
  gem 'guard-rspec',
      git: 'https://github.com/guard/guard-rspec',
      branch: 'rails-5-support',
      require: false
  gem 'guard-brakeman', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'aaf-gumboot',
      git: 'https://github.com/ausaccessfed/aaf-gumboot',
      branch: 'feature/error-pages-compat'
end
