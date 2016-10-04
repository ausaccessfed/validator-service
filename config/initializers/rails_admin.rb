# frozen_string_literal: true
# :nocov:
RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
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
  config.included_models = %w(
    AttributeValue
    Category
    CategoryAttribute
    FederationAttributeAlias
    FederationAttribute
    SnapshotAttributeValue
    Snapshot
    Subject
  )
end
# :nocov:
