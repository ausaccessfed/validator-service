# frozen_string_literal: true

require 'authentication/attribute_helpers'

module Authentication
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include SuperIdentity::Client
    include Rails.application.routes.url_helpers

    def receive(env)
      attrs = map_attributes(env)
      return super if minimally_viable_session?(attrs)

      env['rack.session']['attributes'] = attrs
      redirect_to(failed_snapshots_path)
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

    def finish(_env)
      redirect_to(latest_snapshots_path)
    end

    # :nocov:
    def ide_config
      Rails.application.config.validator_service.ide
    end
    # :nocov:

    private

    def minimally_viable_session?(attrs)
      (persistent_id?(attrs) || targeted_id?(attrs)) && mail?(attrs)
    end

    def persistent_id?(attrs)
      attribute_provided?(attrs, :persistent_id)
    end

    def targeted_id?(attrs)
      attribute_provided?(attrs, :targeted_id)
    end

    def mail?(attrs)
      attribute_provided?(attrs, :mail)
    end

    def attribute_provided?(attrs, ia)
      fa = FederationAttribute.find_by(internal_alias: ia)
      fa.present? && attrs[fa.http_header].present?
    end

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
