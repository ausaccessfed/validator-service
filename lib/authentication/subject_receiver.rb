# frozen_string_literal: true
# Extends the Authentication model
module Authentication
  # Class extending the subject receiver for shib-rack
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include ShibRack::AttributeMapping

    map_single_value  targeted_id:            'HTTP_TARGETED_ID',
                      shared_token:           'HTTP_AUEDUPERSONSHAREDTOKEN',
                      principal_name:         'HTTP_PRINCIPALNAME',
                      name:                   'HTTP_DISPLAYNAME',
                      display_name:           'HTTP_DISPLAYNAME',
                      cn:                     'HTTP_CN',
                      mail:                   'HTTP_MAIL',
                      o:                      'HTTP_O',
                      home_organization:      'HTTP_HOMEORGANIZATION',
                      home_organization_type: 'HTTP_HOMEORGANIZATIONTYPE'

    map_multi_value  affiliation:            'HTTP_EDUPERSONAFFILIATION',
                     scoped_affiliation:     'HTTP_EDUPERSONSCOPEDAFFILIATION'

    def subject(_env, attrs)
      Subject.transaction do
        identifier = attrs.slice(:targeted_id)
        subject = Subject.find_or_initialize_by(identifier)

        subject.enabled = true
        subject.complete = true
        snapshot = Snapshot.new
        subject.snapshots << snapshot

        subject.update!(
          targeted_id: attrs[:targeted_id],
          name: attrs[:name],
          mail: attrs[:mail],
        )

        update_snapshot_attribute_values(snapshot, attrs.except(
          :affiliation,
          :scoped_affiliation)
        )
        update_snapshot_affiliations(snapshot, attrs)
        update_snapshot_scoped_affiliations(snapshot, attrs)

        subject
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end

    def update_snapshot_attribute_values(snapshot, attrs)
      attrs.each do |k, v|
        aaf_attr = AafAttribute.find_or_create_by!(name: k)
        snapshot.attribute_values << AttributeValue.create(value: v, aaf_attribute_id: aaf_attr.id)
      end
    end

    def update_snapshot_affiliations(snapshot, attrs)
      aaf_attr = AafAttribute.find_or_create_by!(name: 'affiliation', singular: false)
      snapshot.attribute_values << AttributeValue.create(value: attrs[:affiliation], aaf_attribute_id: aaf_attr.id)
    end

    def update_snapshot_scoped_affiliations(snapshot, attrs)
      aaf_attr = AafAttribute.find_or_create_by!(name: 'scoped_affiliation', singular: false)
      snapshot.attribute_values << AttributeValue.create(value: attrs[:scoped_affiliation], aaf_attribute_id: aaf_attr.id)
    end

  end
end
