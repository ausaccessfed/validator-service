# frozen_string_literal: true
# Extends the Authentication model
module Authentication
  # Class extending the subject receiver for shib-rack
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include ShibRack::AttributeMapping

    single_values = {}
    multi_values = {}

    if defined? FederationAttribute
      FederationAttribute.all.each do |fa|
        if fa.singular
          single_values[fa.name.to_sym] = fa.http_header
        else
          multi_values[fa.name.to_sym] = fa.http_header
        end
      end

      map_single_value single_values
      map_multi_value multi_values
    end

    def subject(_env, attrs)
      Subject.transaction do
        subject = create_subject(attrs)
        create_snapshot(subject, attrs)
        subject
      end
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
      update_snapshot_attribute_values(
        snapshot,
        attrs.except(:affiliation, :scoped_affiliation))
        update_snapshot_affiliations(snapshot, attrs)
        update_snapshot_scoped_affiliations(snapshot, attrs)
      snapshot
    end

    def update_snapshot_attribute_values(snapshot, attrs)
      attrs.each do |k, v|
        fed_attr = FederationAttribute.find_or_create_by!(name: k, http_header: "HTTP_#{k.upcase}")
        snapshot.attribute_values << AttributeValue.create(
          value: v,
          federation_attribute_id: fed_attr.id)
      end
    end

    def update_snapshot_affiliations(snapshot, attrs)
      affiliation_attr = FederationAttribute.find_by_name('affiliation')

      attrs[:affiliation].each do |affiliation|
        snapshot.attribute_values << AttributeValue.create(
          value: affiliation,
          federation_attribute_id: affiliation_attr.id)
      end
    end

    def update_snapshot_scoped_affiliations(snapshot, attrs)
      scoped_affiliation_attr = FederationAttribute.find_by_name('scoped_affiliation')

      attrs[:scoped_affiliation].each do |scoped_affiliation|
        snapshot.attribute_values << AttributeValue.create(
          value: scoped_affiliation,
          federation_attribute_id: scoped_affiliation_attr.id)
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end
  end
end
