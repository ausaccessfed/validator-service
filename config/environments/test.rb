# frozen_string_literal: true
ValidatorService::Application.configure do
  config.cache_classes = false
  config.eager_load = true
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.shib_rack.test_mode = true
end
