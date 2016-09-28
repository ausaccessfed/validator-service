# frozen_string_literal: true
if Rails.env.production?
  SecureHeaders::Configuration.override(:default) do |config|
    config.csp[:style_src] << 'https://fonts.googleapis.com'
    config.csp[:style_src] << "'unsafe-inline'"
    config.csp[:font_src] << 'https://fonts.gstatic.com'
  end
end
