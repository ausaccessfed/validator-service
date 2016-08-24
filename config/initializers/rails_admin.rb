# frozen_string_literal: true
# :nocov:
RailsAdmin.config do |config|
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

  config.authenticate_with do |controller|
    ensure_authenticated
    @access_checked = true

    unless subject.roles.any?(&:admin_entitlements?)
      redirect_to controller.main_app.root_path
    end
  end
end
# :nocov:
