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

    unless subject.admin?
      message = <<-message
        You are not an admin in test IdE.

        To override this for a development user, add a role with an
        entitlement of `urn:mace:aaf.edu.au:ide:internal:aaf-admin` and
        add an entry to `subject_roles` linking your subject and new role.

        `rails c` eg.
        > r = Role.create!(
            name: 'auto',
            entitlement: 'urn:mace:aaf.edu.au:ide:internal:aaf-admin')
        > s = Subject.find_by(mail: 'jefferey.kohler@ernser.example.edu')
        > s.roles << r
      message

      Rails.logger.debug message

      flash[:notice] = simple_format(message) if Rails.env.development?

      redirect_to controller.main_app.root_path
    end
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
