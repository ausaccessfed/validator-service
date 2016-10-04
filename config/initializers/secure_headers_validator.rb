# frozen_string_literal: true
# :nocov:
if Rails.env.production?
  app_config = Rails.application.config.validator_service

  SecureHeaders::Configuration.override(:default) do |config|
    config.csp[:style_src] << "'unsafe-inline'"
    config.csp[:object_src] << "'self'"

    config.csp[:report_uri] << app_config.secure_headers[:csp][:report_uri]

    config.hpkp = {
      report_only: false,
      max_age: 60.days.to_i,
      include_subdomains: true,
      report_uri: app_config.secure_headers[:hpkp][:report_uri],
      pins: app_config.secure_headers[:hpkp][:pins].map { |h| { sha256: h } }
    }
  end
end
# :nocov:
