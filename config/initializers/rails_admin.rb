# frozen_string_literal: true

# :nocov:
RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      only %w[
        Category
        CategoryAttribute
        FederationAttribute
        FederationAttributeAlias
      ]
    end
    edit
    export
    show
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.authenticate_with do |_controller|
    check_access!('app:validator:admin:web_interface')
  end

  # Note: These are strings to stop `bin/setup`, etc. from crashing.
  config.included_models = %w[
    AttributeValue
    Category
    CategoryAttribute
    FederationAttributeAlias
    FederationAttribute
    SnapshotAttributeValue
    Snapshot
    Subject
  ]
end

AAF::SecureHeaders.development_mode! if Rails.env.development?

SecureHeaders::Configuration.override(:rails_admin) do |config|
  config.csp[:style_src] << "'unsafe-inline'"
  config.csp[:connect_src] = ["'self'"]
  config.csp[:script_src] = config.csp[:script_src] + [
    "'unsafe-eval'",
    "'sha256-73+D8uQwNyLmkFjvaILshPLBcTjapyK9P5FGfkepYxE='",
    "'sha256-2IZ3eH4vQ4iO/yUXEJx3CWqGvsT1mFTk9j1WeznailE='"
    # <script>
    #   jQuery(function($) {
    #
    #   });
    # </script>
  ]
end

Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end

# rubocop:enable Metrics/BlockLength
# :nocov:
