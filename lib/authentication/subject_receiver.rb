# frozen_string_literal: true

require 'authentication/attribute_helpers'

module Authentication
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include SuperIdentity::Client
    include Rails.application.routes.url_helpers

    def receive(env)
      attrs = map_attributes(env)

      missing = {}

      [:targeted_id, :mail].each do |a|
        unless attrs[FederationAttribute.find_by(internal_alias: a).http_header]
               .present?
          missing[a] = true
        end
      end

      return super if missing.empty?

      finish(env, missing)
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

    def finish(_env, missing = [])
      if missing.present?
        missing[:persistent_id_missing] = true

        redirect_to(root_path(missing))
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
        subject.roles << r unless !r || subject.roles.include?(r)

        r
      end

      subject.subject_roles.where.not(role: assigned).destroy_all if assigned
    end
  end
end
