# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength
Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true

  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.shib_rack.development_mode = true

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.raise = true

    Bullet.add_whitelist type: :unused_eager_loading,
                         class_name: 'FederationAttribute',
                         association: :primary_alias
    Bullet.add_whitelist type: :unused_eager_loading,
                         class_name: 'FederationAttributeAlias',
                         association: :federation_attribute
  end
end
# rubocop:enable Metrics/BlockLength
