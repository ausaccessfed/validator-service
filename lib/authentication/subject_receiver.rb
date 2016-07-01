# frozen_string_literal: true

require 'authentication/attribute_helpers'

module Authentication
  class SubjectReceiver
    include ShibRack::DefaultReceiver

    def map_attributes(env)
      Authentication::AttributeHelpers.federation_attributes(env)
    end

    def subject(_env, attrs)
      if FederationAttribute.new_attributes?(attrs.keys)
        # FederationAttribute.new_attributes(attr.keys).each do |attribute|
        #   send_off_to_sqs(attribute)
        # end
      end

      existing_attributes = FederationAttribute.existing_attributes(attrs)

      Subject.transaction do
        subject = Subject.create_from_receiver(existing_attributes)
        Snapshot.create_from_receiver(subject, existing_attributes)
        subject
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end
  end
end
