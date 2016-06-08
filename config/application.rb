require_relative 'boot'

require 'rails/all'
require 'torba/rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ValidatorService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.shib_rack.receiver = 'Authentication::SubjectReceiver'
    config.shib_rack.error_handler = 'Authentication::ErrorHandler'
  end
end
