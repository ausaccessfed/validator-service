# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

require 'torba/rails'

# ValidatorService Module
module ValidatorService
  # Main Rails Application Class
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.shib_rack.receiver = 'Authentication::SubjectReceiver'
    config.shib_rack.error_handler = 'Authentication::ErrorHandler'
  end
end
