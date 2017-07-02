# frozen_string_literal: true

# :nocov:
if Rails.env.production?
  app_config = Rails.application.config.validator_service

  SecureHeaders::Configuration.override(:default) do |config|
    config.csp[:object_src] = ["'self'"]
    config.csp[:report_uri] << app_config.secure_headers[:csp][:report_uri]
  end
end
# :nocov:
