# frozen_string_literal: true
module RapidReceiver
  # Receiver class for rapid-rack
  class AttributeReceiver
    include RapidRack::DefaultReceiver

    include RapidRack::RedisRegistry

    def map_attributes(_env, attrs)
      {
        targeted_id: attrs['edupersontargetedid'],
        name: attrs['displayname'],
        mail: attrs['mail'],
        enabled: true,
        complete: true
      }
    end

    def subject(_env, attrs)
      identifier = attrs.slice(:targeted_id)
      Subject.find_or_initialize_by(identifier).tap do |subject|
        subject.update_attributes!(attrs)
      end
    end

    def finish(_env)
      redirect_to('/welcome/private')
    end
  end
end
