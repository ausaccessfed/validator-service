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

    def map_attributes(env)
      map = {}
      FederationAttribute.all.each do |fa|
        if fa.singular
          map[fa.name.to_sym] = env[fa.http_header]
        else
          map[fa.name.to_sym] = env[fa.http_header].split(';')
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
        next if fed_attr.blank?
        if v.is_a?(Array) # Multi-value attribute
          v.each { |value| create_attr_value(value, fed_attr.id, snapshot) }
        else
          create_attr_value(v, fed_attr.id, snapshot)
        end
      end
    end

    def create_attr_value(value, federation_attribute_id, snapshot)
      av = AttributeValue.new(
        value: value,
        federation_attribute_id: federation_attribute_id)
      snapshot.attribute_values << av
      snapshot.save!
      av
    end

    def finish(_env)
      redirect_to('/dashboard')
    end
  end
end
