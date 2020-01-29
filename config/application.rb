# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'rake'
require 'torba/rails'

Bundler.require(*Rails.groups)

ENV['RAILS_ADMIN_THEME'] = 'aaf_theme'

module ValidatorService
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')

    config.shib_rack.receiver = 'Authentication::SubjectReceiver'
    config.shib_rack.error_handler = 'Authentication::ErrorHandler'

    app_config = YAML.safe_load(Rails.root.join(
      'config/validator_service.yml'
    ).read)
    config.validator_service = OpenStruct.new(app_config.deep_symbolize_keys)

    config.asset_host = config.validator_service.url_options[:base_url]

    config.middleware.use PDFKit::Middleware,
                          {
                            page_size: 'A4',
                            print_media_type: true,
                            zoom: 2
                          },
                          disposition: 'attachment',
                          only: '/snapshots'
  end
end
