# frozen_string_literal: true
module Authentication
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
        subject = Subject.create_from_receiver(attrs)
        Snapshot.create_from_receiver(subject, attrs)
        subject
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end
  end
end
