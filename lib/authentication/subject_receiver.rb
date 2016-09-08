# frozen_string_literal: true

require 'authentication/attribute_helpers'

module Authentication
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include SuperIdentity::Client
    include Rails.application.routes.url_helpers

    def receive(env)
      attrs = map_attributes(env)

      return super if attrs[
        FederationAttribute.find_by(internal_alias: :targeted_id).http_header
      ]

      finish(env, true)
    end

    def map_attributes(env)
      Authentication::AttributeHelpers.federation_attributes(env)
    end

    def subject(_env, attrs)
      existing_attributes = FederationAttribute.existing_attributes(attrs)

      Subject.transaction do
        subject = Subject.create_from_receiver(existing_attributes)
        Snapshot.create_from_receiver(subject, existing_attributes)

        assign_entitlements(
          subject,
          entitlements(subject.shared_token)
        )

        subject
      end
    end

    def finish(_env, failed = false)
      if failed
        redirect_to(root_path(no_targeted_id: true))
      else
        redirect_to(latest_snapshots_path)
      end
    end

    # :nocov:
    def ide_config
      Rails.application.config.validator_service.ide
    end
    # :nocov:

    private

    def assign_entitlements(subject, values)
      assigned = values.map do |value|
        r = Role.find_by(entitlement: value)
        subject.roles << r unless subject.roles.include?(r)

        r
      end

      subject.subject_roles.where.not(role: assigned).destroy_all
    end
  end
end
