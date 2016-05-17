# frozen_string_literal: true
# Extends the Authentication model
module Authentication
  # Class extending the subject receiver for shib-rack
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include ShibRack::AttributeMapping

    def subject(_env, attrs)

      Subject.transaction do
        subject = create_subject(attrs)
        create_snapshot(subject, attrs)
        subject
      end
    end

    def map_attributes(_env)
      map = {}
      FederationAttribute.all.each do |fa|
        if fa.singular
          map[fa.name.to_sym] = _env[fa.http_header]
        else
          map[fa.name.to_sym] = _env[fa.http_header].split(';')
        end
      end
      map
    end

    def create_subject(attrs)
      identifier = attrs.slice(:targeted_id)
      subject = Subject.find_or_initialize_by(identifier) do |s|
        s.enabled = true
        s.complete = true
      end
      subject.update!(name: attrs[:name], mail: attrs[:mail])
      subject
    end

    def create_snapshot(subject, attrs)
      snapshot = Snapshot.new
      subject.snapshots << snapshot
      update_snapshot_attribute_values(snapshot, attrs)
      snapshot
    end

    def update_snapshot_attribute_values(snapshot, attrs)
      attrs.each do |k, v|
        fed_attr = FederationAttribute.find_by_name(k)
        if v.kind_of?(Array) # Multi-value attribute
          v.each do |value|
            snapshot.attribute_values << AttributeValue.create(
              value: value,
              federation_attribute_id: fed_attr.id)
          end
        else
          snapshot.attribute_values << AttributeValue.create(
            value: v,
            federation_attribute_id: fed_attr.id)
        end
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end
  end
end
