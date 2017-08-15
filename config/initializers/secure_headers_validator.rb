# frozen_string_literal: true

# :nocov:

AAF::SecureHeaders.development_mode! if Rails.env.development?

app_config = Rails.application.config.validator_service

SecureHeaders::Configuration.override(:default) do |config|
  config.csp[:object_src] = ["'self'"]

  config.csp[:style_src] = config.csp[:style_src] + [
    "'unsafe-inline'"
  ]

  config.csp[:report_uri] << app_config.secure_headers[:csp][:report_uri]
end

# :nocov:
